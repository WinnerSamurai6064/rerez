import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/generation_settings.dart';
import '../models/rerez_user.dart';
import '../services/api_image_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    ApiImageService? apiImageService,
    ImagePicker? imagePicker,
  })  : _apiImageService = apiImageService ?? ApiImageService(),
        _imagePicker = imagePicker ?? ImagePicker();

  final ApiImageService _apiImageService;
  final ImagePicker _imagePicker;

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

    final cleanedUsername = _cleanUsername(username);
    final usernameError = validateUsername(cleanedUsername);
    final passwordError = validatePassword(password);

    if (usernameError != null || passwordError != null) {
      _setMessage(usernameError ?? passwordError);
      return false;
    }

    _user = RerezUser.loggedIn(
      username: cleanedUsername,
      provider: 'username',
    );
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

    final cleanedUsername = _cleanUsername(username);
    final usernameError = validateUsername(cleanedUsername);
    final passwordError = validatePassword(password);

    if (usernameError != null || passwordError != null) {
      _setMessage(usernameError ?? passwordError);
      return false;
    }

    _user = RerezUser.loggedIn(
      username: cleanedUsername,
      provider: 'username',
    );
    _credits = 20;

    _setMessage(null);
    notifyListeners();
    return true;
  }

  Future<bool> continueWithGoogle() async {
    _setMessage(null);

    _user = RerezUser.loggedIn(
      username: 'Google User',
      provider: 'google',
    );
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

    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

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

  String? validateUsername(String username) {
    final cleaned = _cleanUsername(username);

    if (cleaned.isEmpty) return 'Enter a username.';
    if (cleaned.length < 3) return 'Username must be at least 3 characters.';
    if (cleaned.length > 24) return 'Username must be 24 characters or less.';

    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(cleaned)) {
      return 'Use only letters, numbers, dots, dashes, or underscores.';
    }

    return null;
  }

  String? validatePassword(String password) {
    final value = password.trim();

    if (value.isEmpty) return 'Enter a password.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (_looksSuspicious(value)) return 'Use a safer password.';

    return null;
  }

  String _cleanUsername(String value) {
    return value.trim();
  }

  bool _looksSuspicious(String value) {
    final lower = value.toLowerCase();

    const patterns = [
      '<script',
      '</script',
      'javascript:',
      'onerror=',
      'onload=',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'drop ',
      'union ',
      '--',
      ';--',
      '/*',
      '*/',
      '../',
    ];

    return patterns.any(lower.contains);
  }

  void _setMessage(String? value) {
    _message = value;
    notifyListeners();
  }
}
