import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;


  const ProfileScreen({Key? key, this.onThemeChanged}) : super(key: key);


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkTheme = false;
  bool showPassword = false;


  final String name = "João da Silva";
  final String email = "joao@email.com";
  final String password = "minhaSenha123"; 


  String get encryptedPassword => List.filled(password.length, '•').join();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Informações do Usuário",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(name),
            subtitle: const Text('Nome'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(email),
            subtitle: const Text('Email'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(showPassword ? password : encryptedPassword),
            subtitle: const Text('Senha'),
            trailing: IconButton(
              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text('Tema Claro / Escuro'),
            value: isDarkTheme,
            onChanged: (val) {
              setState(() => isDarkTheme = val);
              widget.onThemeChanged?.call(val);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Implementar futuramente
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Backup e Sincronização'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Implementar futuramente
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context); // ou navegar para login
            },
          ),
        ],
      ),
    );
  }
}
