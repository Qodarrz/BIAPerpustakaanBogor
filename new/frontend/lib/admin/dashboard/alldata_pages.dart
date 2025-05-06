import 'package:flutter/material.dart';
import 'package:projectbia/admin/sidebar_pages.dart';

class AllDataPages extends StatelessWidget {
  const AllDataPages({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      drawer: const AdminDrawer(currentPage: 'all'),
      body: const Center(child: Text('Welcome, Admin! Ini halaman data semua.')),
    );
  }
}
