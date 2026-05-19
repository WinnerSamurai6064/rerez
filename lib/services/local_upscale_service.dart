import 'dart:typed_data';

import '../models/generation_settings.dart';

class LocalUpscaleResult {
  const LocalUpscaleResult({
    required this.ok,
    required this.imageBytes,
    required this.method,
    required this.scale,
    required this.format,
    required this.colorProfile,
    this.width,
    this.height,
    this.error,
  });

  final bool ok;
  final Uint8List? imageBytes;
  final String method;
  final String scale;
  final String format;
  final String colorProfile;
  final int? width;
  final int? height;
  final String? error;

  factory LocalUpscaleResult.failure(String error) {
    return LocalUpscaleResult(
      ok: false,
      imageBytes: null,
      method: '',
      scale: '',
      format: '',
      colorProfile: '',
      error: error,
    );
  }
}

class LocalUpscaleService {
  const LocalUpscaleService();

  Future<LocalUpscaleResult> upscale({
    required Uint8List imageBytes,
    required GenerationSettings settings,
    required bool allowRealEsrganX2,
    required bool allowRealEsrganX4,
  }) async {
    final method = settings.method.label;
    final scale = settings.scale.label;

    if (method == 'Lanczos') {
      return _runLocalLanczos(
        imageBytes: imageBytes,
        settings: settings,
      );
    }

    if (method == 'Real-ESRGAN') {
      if (scale == 'x4' && !allowRealEsrganX4) {
        return LocalUpscaleResult.failure(
          'This device supports Real-ESRGAN x2 only.',
        );
      }

      if (scale == 'x2' && !allowRealEsrganX2) {
        return LocalUpscaleResult.failure(
          'This device cannot run local Real-ESRGAN.',
        );
      }

      return _runLocalRealEsrganPlaceholder(
        imageBytes: imageBytes,
        settings: settings,
      );
    }

    return LocalUpscaleResult.failure('Unsupported processing method.');
  }

  Future<LocalUpscaleResult> _runLocalLanczos({
    required Uint8List imageBytes,
    required GenerationSettings settings,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    return LocalUpscaleResult(
      ok: true,
      imageBytes: imageBytes,
      method: 'Lanczos',
      scale: settings.scale.label,
      format: settings.saveFormat.label,
      colorProfile: settings.colorProfile.label,
    );
  }

  Future<LocalUpscaleResult> _runLocalRealEsrganPlaceholder({
    required Uint8List imageBytes,
    required GenerationSettings settings,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    return LocalUpscaleResult(
      ok: true,
      imageBytes: imageBytes,
      method: 'Real-ESRGAN',
      scale: settings.scale.label,
      format: settings.saveFormat.label,
      colorProfile: settings.colorProfile.label,
    );
  }
}
