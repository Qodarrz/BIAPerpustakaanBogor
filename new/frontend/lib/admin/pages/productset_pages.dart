import 'package:flutter/material.dart';
import 'package:projectbia/admin/sidebar_pages.dart';


class ProductSetPages extends StatelessWidget {
  const ProductSetPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Set Pages')),
      drawer: const AdminDrawer(currentPage: 'product'),
      body: const Center(child: Text('This is the product set pages.')),
    );
  }
}
