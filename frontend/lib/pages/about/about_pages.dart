import 'package:flutter/material.dart';
import 'package:projectbia/pages/navbar_pages.dart';
import 'package:projectbia/pages/header_pages.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';

class AboutPages extends StatefulWidget {
  const AboutPages({super.key});

  @override
  _AboutPagesState createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPages()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomHeader(
              username: "Guest",
              onLogout: () => _logout(context),
              onNotifTap: () {},
              onSearch: (query) {}, // Empty search handler for about page
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome to the About Page!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This application is designed to help you navigate easily and explore various sections like Home, Explore, Favorites, and Profile.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We hope you enjoy using our app!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
    );
  }
}