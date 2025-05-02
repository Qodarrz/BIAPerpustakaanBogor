import 'package:flutter/material.dart';
import 'package:projectbia/pages/splash_screen.dart'; // Ganti dengan path SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), // Mengarahkan ke SplashScreen
    );
  }
}
