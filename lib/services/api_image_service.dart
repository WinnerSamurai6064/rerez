import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/generation_settings.dart';

class ApiGenerationResult {
  const ApiGenerationResult({
    required this.ok,
    required this.resultImageBytes,
    required this.resultUrl,
    required this.downloadUrl,
    required this.filename,
    required this.width,
    required this.height,
    required this.method,
    required this.scale,
    required this.format,
    required this.colorProfile,
    this.error,
  });

  final bool ok;
  final Uint8List? resultImageBytes;
  final String? resultUrl;
  final String? downloadUrl;
  final String? filename;
  final int? width;
  final int? height;
  final String? method;
  final String? scale;
  final String? format;
  final String? colorProfile;
  final String? error;

  factory ApiGenerationResult.failure(String error) {
    return ApiGenerationResult(
      ok: false,
      resultImageBytes: null,
      resultUrl: null,
      downloadUrl: null,
      filename: null,
      width: null,
      height: null,
      method: null,
      scale: null,
      format: null,
      colorProfile: null,
      error: error,
    );
  }
}

class ApiImageService {
  ApiImageService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String backendBaseUrl = 'https://ericaluvgemma-rerez.hf.space';

  Future<ApiGenerationResult> generate({
    required Uint8List imageBytes,
    required String filename,
    required GenerationSettings settings,
  }) async {
    try {
      final uri = Uri.parse('$backendBaseUrl/jobs/generate');

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'X-Rerez-Client': 'flutter-web',
      });

      request.fields.addAll({
        'scale': settings.scale.label,
        'method': settings.method.label,
        'colorProfile': settings.colorProfile.label,
        'filter': settings.filter.label,
        'saveFormat': settings.saveFormat.label,
        'platform': 'flutter-web',
        'deviceTier': 'web',
        'usedBackendFallback': 'true',
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: _safeFilename(filename),
          contentType: _contentTypeForFilename(filename),
        ),
      );

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      final decoded = _decodeJson(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return ApiGenerationResult.failure(
          decoded?['error']?.toString() ??
              'Backend error ${response.statusCode}: ${response.body}',
        );
      }

      if (decoded == null || decoded['ok'] != true) {
        return ApiGenerationResult.failure(
          decoded?['error']?.toString() ?? 'Invalid backend response.',
        );
      }

      final resultUrl = decoded['resultFile']?['url']?.toString();
      final downloadUrl = decoded['download']?['url']?.toString();
      final previewUrl = resultUrl ?? downloadUrl;

      Uint8List? resultBytes;

      if (previewUrl != null && previewUrl.isNotEmpty) {
        try {
          resultBytes = await _fetchResult(pathOrUrl: previewUrl);
        } catch (_) {
          resultBytes = null;
        }
      }

      final output = decoded['output'];

      return ApiGenerationResult(
        ok: true,
        resultImageBytes: resultBytes,
        resultUrl: resultUrl,
        downloadUrl: downloadUrl,
        filename: decoded['download']?['filename']?.toString() ??
            decoded['resultFile']?['filename']?.toString(),
        width: _readInt(output?['width']),
        height: _readInt(output?['height']),
        method: output?['method']?.toString(),
        scale: output?['scale']?.toString(),
        format: output?['format']?.toString(),
        colorProfile: output?['colorProfile']?.toString(),
      );
    } catch (error) {
      return ApiGenerationResult.failure(
        'Could not reach backend: $error',
      );
    }
  }

  Future<Uint8List> downloadResult({
    required String pathOrUrl,
  }) {
    return _fetchResult(pathOrUrl: pathOrUrl);
  }

  Future<Uint8List> _fetchResult({
    required String pathOrUrl,
  }) async {
    final uri = _resolveBackendUri(pathOrUrl);

    final response = await _client.get(
      uri,
      headers: {
        'X-Rerez-Client': 'flutter-web',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Could not load result image: ${response.statusCode}');
    }

    return response.bodyBytes;
  }

  Uri _resolveBackendUri(String pathOrUrl) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return Uri.parse(pathOrUrl);
    }

    final normalizedPath = pathOrUrl.startsWith('/') ? pathOrUrl : '/$pathOrUrl';
    return Uri.parse('$backendBaseUrl$normalizedPath');
  }

  MediaType _contentTypeForFilename(String filename) {
    final lower = filename.toLowerCase();

    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }

    if (lower.endsWith('.png')) {
      return MediaType('image', 'png');
    }

    if (lower.endsWith('.webp')) {
      return MediaType('image', 'webp');
    }

    if (lower.endsWith('.gif')) {
      return MediaType('image', 'gif');
    }

    if (lower.endsWith('.heic')) {
      return MediaType('image', 'heic');
    }

    if (lower.endsWith('.heif')) {
      return MediaType('image', 'heif');
    }

    return MediaType('image', 'png');
  }

  String _safeFilename(String filename) {
    final cleaned = filename.trim();

    if (cleaned.isEmpty) {
      return 'rerez-image.png';
    }

    if (cleaned.contains('.')) {
      return cleaned;
    }

    return '$cleaned.png';
  }

  Map<String, dynamic>? _decodeJson(String value) {
    try {
      final decoded = jsonDecode(value);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
