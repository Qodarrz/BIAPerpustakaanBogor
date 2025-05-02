import 'package:flutter/material.dart';
import 'dart:async';
import 'package:projectbia/pages/auth/login_pages.dart'; // Ganti dengan path LoginPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Fungsi untuk delay dan pindah ke LoginPage setelah beberapa detik
  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    // Setelah 3 detik, pindah ke LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()), // Mengarahkan ke LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_image.png'),  // Gambar Splash Screen
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
