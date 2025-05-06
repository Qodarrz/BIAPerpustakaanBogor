import 'package:flutter/material.dart';
import 'package:projectbia/user/navbar_pages.dart';
import 'package:projectbia/user/header_pages.dart';
import 'package:projectbia/user/book/bookdetail_pages.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final List<Map<String, dynamic>> popularBooks = [
    {
      'title': 'Laskar Pelangi',
      'image': 'assets/images/laskarpelangi.jpg',
      'author': 'Andrea Hirata',
      'category': 'Novel',
      'rating': 4.8,
      'pages': 529,
      'description': 'Novel tentang persahabatan sekelompok anak di Belitung',
      'code': 'LP001',
      'publisher': 'Bentang Pustaka',
      'year': 2005,
      'floor': 2,
      'shelf': 'A3',
      'is_active': true,
      'cover': 'assets/images/laskarpelangi.jpg'
    },
    {
      'title': 'Filosofi Teras',
      'image': 'assets/images/laskarpelangi.jpg',
      'author': 'Henry Manampiring',
      'category': 'Filosofi',
      'rating': 4.7,
      'pages': 320,
      'description': 'Pengantar filsafat stoikisme untuk kehidupan modern',
      'code': 'FT002',
      'publisher': 'Kompas',
      'year': 2018,
      'floor': 1,
      'shelf': 'B2',
      'is_active': true,
      'cover': 'assets/images/laskarpelangi.jpg'
    },
    // Add more books with complete data
  ];

  final List<Map<String, dynamic>> newReleases = [
    {
      'title': 'Laut Bercerita',
      'image': 'assets/images/laskarpelangi.jpg',
      'author': 'Leila S. Chudori',
      'category': 'Novel',
      'rating': 4.9,
      'pages': 379,
      'description': 'Novel tentang sejarah kelam Indonesia',
      'code': 'LB003',
      'publisher': 'Kepustakaan Populer Gramedia',
      'year': 2021,
      'floor': 2,
      'shelf': 'C1',
      'is_active': true,
      'cover': 'assets/images/laskarpelangi.jpg'
    },
    // Add more books
  ];

  final List<Map<String, dynamic>> recommendedBooks = [
    {
      'title': 'Atomic Habits',
      'image': 'assets/images/laskarpelangi.jpg',
      'author': 'James Clear',
      'category': 'Pengembangan Diri',
      'rating': 4.9,
      'pages': 320,
      'description': 'Membangun kebiasaan baik dan menghilangkan kebiasaan buruk',
      'code': 'AH004',
      'publisher': 'Gramedia',
      'year': 2018,
      'floor': 1,
      'shelf': 'D4',
      'is_active': true,
      'cover': 'assets/images/laskarpelangi.jpg'
    },
    // Add more books
  ];

  final List<String> categories = [
    'Trending',
    'Novel',
    'Komik',
    'Edukasi',
    'Paling Dicari',
    'Inspirasi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSectionTitle('Kategori Populer'),
              const SizedBox(height: 8),
              _buildCategoryGrid(),
              const SizedBox(height: 24),
              _buildBookSlider('Buku Populer', popularBooks),
              const SizedBox(height: 24),
              _buildBookSlider('Rilis Terbaru', newReleases),
              const SizedBox(height: 24),
              _buildBookSlider('Rekomendasi Untukmu', recommendedBooks),
              const SizedBox(height: 24),
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
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBookSlider(String title, List<Map<String, dynamic>> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return _buildBookCard(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPages(
              book: book,
              title: book['title'] ?? 'No Title',
              imagePath: book['image'] ?? '',
            ),
          ),
        );
      },
      child: SizedBox(
        width: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'book-cover-${book['title']}',
              child: Container(
                width: 140,
                height: 180,
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
                  child: Image.asset(
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
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: categories.map(_buildCategoryChip).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return InkWell(
      onTap: () {
        // Add category tap functionality
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _getCategoryColor(label),
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
            Icon(_getCategoryIcon(label), size: 18, color: Colors.black54),
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

  Color _getCategoryColor(String label) {
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
    return colors[label.length % colors.length];
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Trending':
        return Icons.whatshot;
      case 'Novel':
        return Icons.book;
      case 'Komik':
        return Icons.collections_bookmark;
      case 'Edukasi':
        return Icons.school;
      case 'Paling Dicari':
        return Icons.search;
      case 'Inspirasi':
        return Icons.lightbulb_outline;
      default:
        return Icons.label_important;
    }
  }
}