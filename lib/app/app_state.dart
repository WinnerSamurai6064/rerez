import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/generation_settings.dart';
import '../models/rerez_user.dart';
import '../services/api_image_service.dart';
import '../services/mock_auth_service.dart';
import '../services/mock_image_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    MockAuthService? authService,
    MockImageService? imageService,
    ApiImageService? apiImageService,
  })  : _authService = authService ?? MockAuthService(),
        _imageService = imageService ?? MockImageService(),
        _apiImageService = apiImageService ?? ApiImageService();

  final MockAuthService _authService;
  final MockImageService _imageService;
  final ApiImageService _apiImageService;

  RerezUser _user = RerezUser.guest();
  int _credits = 2;

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  Uint8List? _resultImageBytes;
  String? _resultUrl;
  String? _downloadUrl;
  String? _resultFilename;
  int? _resultWidth;
  int? _resultHeight;
  String? _resultMethod;
  String? _resultScale;
  String? _resultFormat;
  String? _resultColorProfile;

  GenerationSettings _settings = const GenerationSettings();
  bool _isGenerating = false;
  String? _message;

  RerezUser get user => _user;
  int get credits => _credits;

  XFile? get selectedImage => _selectedImage;
  Uint8List? get selectedImageBytes => _selectedImageBytes;

  Uint8List? get resultImageBytes => _resultImageBytes;
  String? get resultUrl => _resultUrl;
  String? get downloadUrl => _downloadUrl;
  String? get resultFilename => _resultFilename;
  int? get resultWidth => _resultWidth;
  int? get resultHeight => _resultHeight;
  String? get resultMethod => _resultMethod;
  String? get resultScale => _resultScale;
  String? get resultFormat => _resultFormat;
  String? get resultColorProfile => _resultColorProfile;

  GenerationSettings get settings => _settings;
  bool get isGenerating => _isGenerating;
  String? get message => _message;

  bool get isLoggedIn => _user.isLoggedIn;
  bool get hasSelectedImage => _selectedImageBytes != null;
  bool get hasResultImage => _resultImageBytes != null;
  bool get hasCredits => _credits > 0;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setMessage(null);

    final result = await _authService.login(
      username: username,
      password: password,
    );

    if (!result.isSuccess || result.user == null) {
      _setMessage(result.message);
      return false;
    }

    _user = result.user!;
    _credits = 20;
    _setMessage(null);
    notifyListeners();
    return true;
  }

  Future<bool> signUp({
    required String username,
    required String password,
  }) async {
    _setMessage(null);

    final result = await _authService.signUp(
      username: username,
      password: password,
    );

    if (!result.isSuccess || result.user == null) {
      _setMessage(result.message);
      return false;
    }

    _user = result.user!;
    _credits = 20;
    _setMessage(null);
    notifyListeners();
    return true;
  }

  Future<bool> continueWithGoogle() async {
    _setMessage(null);

    final result = await _authService.continueWithGoogle();

    if (!result.isSuccess || result.user == null) {
      _setMessage(result.message);
      return false;
    }

    _user = result.user!;
    _credits = 20;
    _setMessage(null);
    notifyListeners();
    return true;
  }

  void logout() {
    _user = RerezUser.guest();
    _credits = 2;
    clearTemporarySession();
    _setMessage(null);
    notifyListeners();
  }

  Future<void> pickImage() async {
    _setMessage(null);

    final pickedImage = await _imageService.pickImage();

    if (pickedImage == null) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();

    _selectedImage = pickedImage;
    _selectedImageBytes = bytes;
    clearResultOnly();
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    _selectedImageBytes = null;
    clearResultOnly();
    notifyListeners();
  }

  void updateSettings(GenerationSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  void updateScale(ScaleOption scale) {
    _settings = _settings.copyWith(scale: scale);
    notifyListeners();
  }

  void updateMethod(ProcessingMethod method) {
    _settings = _settings.copyWith(method: method);
    notifyListeners();
  }

  void updateColorProfile(ColorProfile colorProfile) {
    _settings = _settings.copyWith(colorProfile: colorProfile);
    notifyListeners();
  }

  void updateFilter(FilterOption filter) {
    _settings = _settings.copyWith(filter: filter);
    notifyListeners();
  }

  void updateSaveFormat(SaveFormat saveFormat) {
    _settings = _settings.copyWith(saveFormat: saveFormat);
    notifyListeners();
  }

  Future<bool> generate() async {
    _setMessage(null);

    if (!hasSelectedImage || _selectedImageBytes == null) {
      _setMessage('Select an image first.');
      return false;
    }

    if (!hasCredits) {
      _setMessage('No credits remaining.');
      return false;
    }

    _isGenerating = true;
    clearResultOnly();
    notifyListeners();

    final filename = _selectedImage?.name.trim().isNotEmpty == true
        ? _selectedImage!.name
        : 'rerez-image.png';

    final result = await _apiImageService.generate(
      imageBytes: _selectedImageBytes!,
      filename: filename,
      settings: _settings,
    );

    _isGenerating = false;

    if (!result.ok) {
      _setMessage(result.error ?? 'Generation failed.');
      notifyListeners();
      return false;
    }

    _resultImageBytes = result.resultImageBytes;
    _resultUrl = result.resultUrl;
    _downloadUrl = result.downloadUrl;
    _resultFilename = result.filename;
    _resultWidth = result.width;
    _resultHeight = result.height;
    _resultMethod = result.method;
    _resultScale = result.scale;
    _resultFormat = result.format;
    _resultColorProfile = result.colorProfile;

    _credits -= 1;
    _setMessage(null);
    notifyListeners();

    return true;
  }

  void clearMessage() {
    _setMessage(null);
  }

  void clearResultOnly() {
    _resultImageBytes = null;
    _resultUrl = null;
    _downloadUrl = null;
    _resultFilename = null;
    _resultWidth = null;
    _resultHeight = null;
    _resultMethod = null;
    _resultScale = null;
    _resultFormat = null;
    _resultColorProfile = null;
  }

  void clearTemporarySession() {
    _selectedImage = null;
    _selectedImageBytes = null;
    clearResultOnly();
    _settings = const GenerationSettings();
    _isGenerating = false;
  }

  void _setMessage(String? value) {
    _message = value;
    notifyListeners();
  }
}
