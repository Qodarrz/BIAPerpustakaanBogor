import 'package:flutter/material.dart';
import 'package:projectbia/user/auth/login_pages.dart';
import 'package:projectbia/user/auth/register_pages.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/admin/dashboard/alldata_pages.dart';
import 'package:projectbia/user/home/home_pages.dart';
import 'package:projectbia/user/routes/route_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      onGenerateRoute: AppRoutes.generateRoute,
      
   routes: {
  '/welcome': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginPages(),
  '/register': (context) => const RegisterPages(),
  '/admin': (context) => const AllDataPages(), // admin layout utama
  '/user': (context) => HomePages(),   // user layout utama
},

    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;
  final String _logoPath = "assets/images/logo1.png";

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
  Future.delayed(const Duration(milliseconds: 300), () {
    if (mounted) {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    }
  });

  Future.delayed(const Duration(seconds: 2, milliseconds: 500), () async {
  if (!mounted) return;

  bool loggedIn = await AuthService.isLoggedIn();
  if (loggedIn) {
    String? role = await AuthService.getRole();
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      Navigator.pushReplacementNamed(context, '/user');
    }
  } else {
    Navigator.pushReplacementNamed(context, '/user');
  }
});

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: _opacity,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 800),
            scale: _scale,
            curve: Curves.easeOutBack,
            child: _buildWelcomeContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAppLogo(),
        const SizedBox(height: 32),
        const SizedBox(height: 16),
        _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          _logoPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => 
              const Icon(Icons.error_outline, size: 50),
        ),
      ),
    );
  }



  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 100,
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        color: Colors.deepPurple,
        minHeight: 2,
      ),
    );
  }
}