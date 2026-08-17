class User {
  final String id;
  final String fullName;
  final String email;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory User.fromJwt(Map<String, dynamic> payload) {
    return User(
      id: payload['sub'] ?? '',
      fullName: payload['fullName'] ?? 'Sobat Olahraga',
      email: payload['email'] ?? '',
      role: payload['role'] ?? 'Masyarakat',
    );
  }
}
