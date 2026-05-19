class RerezUser {
  const RerezUser({
    required this.username,
    required this.isLoggedIn,
    required this.provider,
  });

  final String username;
  final bool isLoggedIn;
  final String provider;

  factory RerezUser.guest() {
    return const RerezUser(
      username: 'Guest',
      isLoggedIn: false,
      provider: 'guest',
    );
  }

  factory RerezUser.loggedIn({
    required String username,
    String provider = 'username',
  }) {
    return RerezUser(
      username: username.trim().isEmpty ? 'User' : username.trim(),
      isLoggedIn: true,
      provider: provider,
    );
  }

  String get accountStatus => isLoggedIn ? 'Logged in' : 'Guest';

  RerezUser copyWith({
    String? username,
    bool? isLoggedIn,
    String? provider,
  }) {
    return RerezUser(
      username: username ?? this.username,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      provider: provider ?? this.provider,
    );
  }
}
