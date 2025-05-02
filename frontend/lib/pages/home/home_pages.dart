import 'package:flutter/material.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await AuthService();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di E-Layanan Publik!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
