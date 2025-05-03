import 'package:flutter/material.dart';
import 'package:projectbia/pages/header_pages.dart'; // Assuming CustomHeader is here
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';

import 'package:projectbia/pages/navbar_pages.dart';

class MarketPages extends StatefulWidget {
  const MarketPages({super.key});

  @override
  State<MarketPages> createState() => _MarketPagesState();
}

class _MarketPagesState extends State<MarketPages> {
  // Sample market items data
  final List<Map<String, dynamic>> _marketItems = [
    {
      'name': 'Organic Apples',
      'price': '\$2.99',
      'image': '🍎',
      'color': Colors.red[100],
      'rating': 4.5,
    },
    {
      'name': 'Fresh Bread',
      'price': '\$3.49',
      'image': '🍞',
      'color': Colors.orange[100],
      'rating': 4.2,
    },
    {
      'name': 'Dairy Milk',
      'price': '\$1.99',
      'image': '🥛',
      'color': Colors.blue[100],
      'rating': 4.7,
    },
    {
      'name': 'Organic Eggs',
      'price': '\$4.99',
      'image': '🥚',
      'color': Colors.yellow[100],
      'rating': 4.8,
    },
  ];

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
      body: Column(
        children: [
          // Custom Header
          CustomHeader(
            username: "Guest",
            onLogout: () => _logout(context),
            onNotifTap: () {
              // Handle notification tap
            },
            onSearch: (query) {
              // Handle search functionality
            },
          ),

          // Market Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fresh Market',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find the best products at affordable prices',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Categories Chips
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('All', true),
                        _buildCategoryChip('Fruits', false),
                        _buildCategoryChip('Vegetables', false),
                        _buildCategoryChip('Dairy', false),
                        _buildCategoryChip('Bakery', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Products Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: _marketItems.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_marketItems[index]);
                      },
                    ),
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

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle category selection
        },
        selectedColor: Colors.green[300],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(item['image'], style: const TextStyle(fontSize: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['price'],
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[400], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      item['rating'].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
