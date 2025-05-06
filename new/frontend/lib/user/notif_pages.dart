import 'package:flutter/material.dart';
import 'package:projectbia/user/navbar_pages.dart'; // Assuming CheerfulMinimalistNavBar is here
import 'package:projectbia/user/header_pages.dart'; 
class NotifPages extends StatelessWidget {
  const NotifPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          const CustomHeader(), // Assuming CustomHeader is defined in header_pages
        Expanded(
          child: const Center(
            child: Text('This is the Notifications Page'),
          ),
        ),
          const CheerfulMinimalistNavBar(), // Assuming CustomNavbar is defined in navbar_pages
        ],
      ),
      
    );
  }
}