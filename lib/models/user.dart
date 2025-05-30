import '/models/user.dart';

class AppUser {
  final String name;
  final String email;
  final String password;

  AppUser({
    required this.name,
    required this.email,
    required this.password,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
