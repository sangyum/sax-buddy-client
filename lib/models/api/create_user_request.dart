class CreateUserRequest {
  final String email;
  final String name;

  CreateUserRequest({
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
    };
  }
}