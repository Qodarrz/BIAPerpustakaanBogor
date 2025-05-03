import 'package:flutter/material.dart';
import 'package:projectbia/pages/navbar_pages.dart';
import 'package:projectbia/pages/header_pages.dart';

class BookPages extends StatelessWidget {
  const BookPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Books'),
      ),
      body: const Center(
        child: Text('This is the Book Page!'),
      ),
      bottomNavigationBar: const CheerfulMinimalistNavBar(), // ← dipindah ke dalam Scaffold
    );
  }
}
