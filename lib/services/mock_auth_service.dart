import '../models/rerez_user.dart';

class MockAuthResult {
  const MockAuthResult({
    required this.isSuccess,
    required this.message,
    this.user,
  });

  final bool isSuccess;
  final String message;
  final RerezUser? user;

  factory MockAuthResult.success(RerezUser user) {
    return MockAuthResult(
      isSuccess: true,
      message: 'Success',
      user: user,
    );
  }

  factory MockAuthResult.failure(String message) {
    return MockAuthResult(
      isSuccess: false,
      message: message,
    );
  }
}

class MockAuthService {
  final Set<String> _reservedUsernames = {
    'admin',
    'root',
    'system',
    'rerez',
    'treytek',
  };

  final Map<String, String> _mockUsers = {};

  Future<MockAuthResult> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final cleanUsername = _cleanUsername(username);
    final usernameError = validateUsername(cleanUsername);
    final passwordError = validatePassword(password);

    if (usernameError != null) {
      return MockAuthResult.failure(usernameError);
    }

    if (passwordError != null) {
      return MockAuthResult.failure(passwordError);
    }

    if (_reservedUsernames.contains(cleanUsername.toLowerCase())) {
      return MockAuthResult.failure('This username is unavailable.');
    }

    _mockUsers.putIfAbsent(cleanUsername.toLowerCase(), () => password);

    return MockAuthResult.success(
      RerezUser.loggedIn(username: cleanUsername),
    );
  }

  Future<MockAuthResult> signUp({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final cleanUsername = _cleanUsername(username);
    final usernameError = validateUsername(cleanUsername);
    final passwordError = validatePassword(password);

    if (usernameError != null) {
      return MockAuthResult.failure(usernameError);
    }

    if (passwordError != null) {
      return MockAuthResult.failure(passwordError);
    }

    final usernameKey = cleanUsername.toLowerCase();

    if (_reservedUsernames.contains(usernameKey) ||
        _mockUsers.containsKey(usernameKey)) {
      return MockAuthResult.failure('This username is unavailable.');
    }

    _mockUsers[usernameKey] = password;

    return MockAuthResult.success(
      RerezUser.loggedIn(username: cleanUsername),
    );
  }

  Future<MockAuthResult> continueWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 550));

    return MockAuthResult.success(
      RerezUser.loggedIn(username: 'Google User'),
    );
  }

  String? validateUsername(String username) {
    final cleanUsername = _cleanUsername(username);

    if (cleanUsername.isEmpty) {
      return 'Enter a username.';
    }

    if (cleanUsername.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    if (cleanUsername.length > 24) {
      return 'Username must be 24 characters or less.';
    }

    final safeUsernamePattern = RegExp(r'^[a-zA-Z0-9._-]+$');

    if (!safeUsernamePattern.hasMatch(cleanUsername)) {
      return 'Use only letters, numbers, dots, dashes, or underscores.';
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.trim().isEmpty) {
      return 'Enter a password.';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    if (_looksSuspicious(password)) {
      return 'Use a safer password.';
    }

    return null;
  }

  String _cleanUsername(String username) {
    return username.trim();
  }

  bool _looksSuspicious(String value) {
    final lower = value.toLowerCase();

    final suspiciousPatterns = <String>[
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

    return suspiciousPatterns.any(lower.contains);
  }
}
