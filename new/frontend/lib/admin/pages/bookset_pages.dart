import 'package:flutter/material.dart';
import 'package:projectbia/admin/sidebar_pages.dart';

class BookSetPages extends StatelessWidget {
  const BookSetPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Set Pages')),
      drawer: const AdminDrawer(currentPage: 'book'),
      body: const Center(child: Text('This is the book set pages.')),
    );
  }
}
