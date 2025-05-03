import 'package:flutter/material.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';
import 'package:projectbia/pages/navbar_pages.dart';
import 'package:projectbia/pages/header_pages.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  void _logout(BuildContext context) async {
    await AuthService();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPages()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              CustomHeader(
                username: "Guest",
                onLogout: () => _logout(context),
                onNotifTap: () {},
                onSearch: (query) {},
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori Populer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPinterestGrid(),
                    const SizedBox(height: 24),
                    _buildBookSlider(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Selamat Datang di E-Layanan Publik!',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
    );
  }

  Widget _buildBookSlider() {
    // Dummy data buku
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Buku Populer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        // Biar fleksibel dan ga overflow
        SizedBox(
          height: 240, // total tinggi container buku + judul + spacing
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
                  // Cover buku
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

                  // Judul buku
                  SizedBox(
                    width: 140,
                    child: Text(
                      book['title'] ?? '',
                      textAlign:
                          TextAlign.center, // ini bikin teksnya di tengah
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

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          categories.map((label) => _buildRoundedCategoryCard(label)).toList(),
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

    return Container(
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
          Icon(_getSmallCategoryIcon(label), size: 18, color: Colors.black54),
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
