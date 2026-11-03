class AuthUser {
  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.token = '',
    this.refreshToken,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String token;
  final String? refreshToken;

  String get fullName => '$firstName $lastName'.trim();

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as int? ?? 0,
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        image: json['image']?.toString(),
        // DummyJSON returns `accessToken`; older versions returned `token`.
        token: (json['accessToken'] ?? json['token'] ?? '').toString(),
        refreshToken: json['refreshToken']?.toString(),
      );
}
