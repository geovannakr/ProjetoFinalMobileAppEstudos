import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool)? onThemeChanged;

  const ProfileScreen({
    Key? key,
    this.isDarkTheme = false,
    this.onThemeChanged,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isDarkTheme;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkTheme ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkTheme ? Colors.white : const Color(0xFF1565C0);
    final cardColor = isDarkTheme ? const Color(0xFF1A1A1A) : const Color(0xFFF1F7FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset(
                'lib/assets/image.png', // Seu logo
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SwitchListTile(
              title: Text(
                'Tema Claro / Escuro',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              value: isDarkTheme,
              onChanged: (val) {
                setState(() {
                  isDarkTheme = val;
                });
                widget.onThemeChanged?.call(val);
              },
              activeColor: Colors.blueAccent,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 32),

          ListTile(
            tileColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }
} 