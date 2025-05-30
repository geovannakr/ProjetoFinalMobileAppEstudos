// lib/services/auth_service.dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal();

  String? _loggedInEmail;

  // Simula login
  Future<bool> login(String email, String password) async {
    // Aqui você pode usar FirebaseAuth ou simular usuários
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@edutrack.com' && password == '123456') {
      _loggedInEmail = email;
      return true;
    }
    return false;
  }

  // Simula logout
  void logout() {
    _loggedInEmail = null;
  }

  // Verifica se o usuário está logado
  bool isLoggedIn() {
    return _loggedInEmail != null;
  }

  // Retorna o e-mail do usuário logado
  String? getUserEmail() {
    return _loggedInEmail;
  }
}
