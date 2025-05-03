import 'package:flutter/material.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';
import 'package:projectbia/pages/navbar_pages.dart';
import 'package:projectbia/pages/header_pages.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  Future<void> _logout(BuildContext context) async {
    await AuthService(); // Ensure AuthService implements logout
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPages()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(
                username: "Guest",
                onLogout: () => _logout(context),
                onNotifTap: () {},
                onSearch: (query) {},
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSectionTitle('Kategori Populer'),
              const SizedBox(height: 8),
              _buildPinterestGrid(),
              const SizedBox(height: 24),
              _buildBookSlider(),
              const SizedBox(height: 24),
              _buildWelcomeText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search something...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          // Add search logic if needed
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Selamat Datang di E-Layanan Publik!',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBookSlider() {
    final books = [
      {'title': 'Laskar Pelangi', 'image': 'assets/images/laskarpelangi.jpg'},
      {'title': 'Filosofi Teras', 'image': 'assets/images/laskarpelangi.jpg'},
      {'title': 'Bumi', 'image': 'assets/images/laskarpelangi.jpg'},
      {'title': 'Mariposa', 'image': 'assets/images/laskarpelangi.jpg'},
      {'title': 'Negeri 5 Menara', 'image': 'assets/images/laskarpelangi.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Buku Populer'),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        book['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 140,
                    child: Text(
                      book['title'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPinterestGrid() {
    final categories = [
      'Trending',
      'Best Seller',
      'Novel',
      'Komik',
      'Edukasi',
      'Paling Dicari',
      'Referensi Kuliah',
      'Inspirasi',
      'Top Picks',
      'Dunia',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            categories.map((label) => _buildRoundedCategoryCard(label)).toList(),
      ),
    );
  }

  Widget _buildRoundedCategoryCard(String label) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.red.shade100,
      Colors.teal.shade100,
      Colors.pink.shade100,
      Colors.amber.shade100,
      Colors.indigo.shade100,
      Colors.cyan.shade100,
    ];
    final color = colors[label.length % colors.length];

    return InkWell(
      onTap: () {
        // Add category tap functionality
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getSmallCategoryIcon(label), 
            size: 18, 
            color: Colors.black54),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSmallCategoryIcon(String category) {
    switch (category) {
      case 'Trending':
        return Icons.whatshot;
      case 'Best Seller':
        return Icons.grade;
      case 'Novel':
        return Icons.book;
      case 'Komik':
        return Icons.collections_bookmark;
      case 'Edukasi':
        return Icons.school;
      case 'Inspirasi':
        return Icons.lightbulb_outline;
      case 'Top Picks':
        return Icons.workspace_premium;
      case 'Dunia':
        return Icons.language;
      case 'Paling Dicari':
        return Icons.search;
      case 'Referensi Kuliah':
        return Icons.menu_book;
      default:
        return Icons.label_important;
    }
  }
}