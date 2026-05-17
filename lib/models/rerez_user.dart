class RerezUser {
  const RerezUser({
    required this.username,
    required this.isGuest,
  });

  final String username;
  final bool isGuest;

  bool get isLoggedIn => !isGuest;

  factory RerezUser.guest() {
    return const RerezUser(
      username: 'Guest',
      isGuest: true,
    );
  }

  factory RerezUser.loggedIn({
    required String username,
  }) {
    return RerezUser(
      username: username,
      isGuest: false,
    );
  }

  RerezUser copyWith({
    String? username,
    bool? isGuest,
  }) {
    return RerezUser(
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
