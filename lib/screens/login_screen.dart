import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;

  const LoginScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text("Entrar"),
                ),
                const SizedBox(height: 16),
               
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
