import 'package:flutter/material.dart';
import 'package:projectbia/admin/sidebar_pages.dart';


class RecommPages extends StatelessWidget {
  const RecommPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendation Pages')),
      drawer: const AdminDrawer(currentPage: 'recomm'),
      body: const Center(child: Text('This is the recommendation pages.')),
    );
  }
}
