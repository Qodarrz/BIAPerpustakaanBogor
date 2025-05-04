import 'package:flutter/material.dart';
import 'package:projectbia/pages/navbar_pages.dart';
import 'package:projectbia/pages/header_pages.dart';
import 'package:projectbia/service/auth/auth_service.dart';
import 'package:projectbia/pages/auth/login_pages.dart';

class BookPages extends StatefulWidget {
  const BookPages({super.key});

  @override
  _BookPagesState createState() => _BookPagesState();
}

class _BookPagesState extends State<BookPages> {
  final List<Map<String, dynamic>> _books = [
    {
      'title': 'Flutter Essentials',
      'author': 'John Doe',
      'category': 'Programming',
      'color': Colors.blue[200],
      'rating': 4.5,
      'cover': 'assets/images/laskarpelangi.jpg',
      'pages': 320,
    },
    {
      'title': 'Design Patterns',
      'author': 'Jane Smith',
      'category': 'Computer Science',
      'color': Colors.purple[200],
      'rating': 4.8,
      'cover': 'assets/images/laskarpelangi.jpg',
      'pages': 410,
    },
    {
      'title': 'Clean Code',
      'author': 'Robert Martin',
      'category': 'Software Engineering',
      'color': Colors.green[200],
      'rating': 4.7,
      'cover': 'assets/images/laskarpelangi.jpg',
      'pages': 288,
    },
    {
      'title': 'The Art of Programming',
      'author': 'Donald Knuth',
      'category': 'Algorithms',
      'color': Colors.orange[200],
      'rating': 4.9,
      'cover': 'assets/images/laskarpelangi.jpg',
      'pages': 672,
    },
    {
      'title': 'Deep Learning',
      'author': 'Ian Goodfellow',
      'category': 'Artificial Intelligence',
      'color': Colors.red[200],
      'rating': 4.6,
      'cover': 'assets/images/laskarpelangi.jpg',
      'pages': 800,
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPages()),
    );
  }

  List<Map<String, dynamic>> get _filteredBooks {
    return _books.where((book) {
      final matchesSearch = book['title'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          book['author'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || 
                            book['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ..._books.map((b) => b['category']).toSet().toList()];
    
    // Map categories to their respective icons
    final categoryIcons = {
      'All': Icons.all_inclusive,
      'Programming': Icons.code,
      'Computer Science': Icons.computer,
      'Software Engineering': Icons.engineering,
      'Algorithms': Icons.functions,
      'Artificial Intelligence': Icons.psychology,
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomHeader(
              username: "Guest",
              onLogout: () => _logout(context),
              onNotifTap: () {},
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Row(
                          children: [
                            Icon(
                              categoryIcons[category],
                              size: 18,
                              color: isSelected ? Colors.white : Colors.pink,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: Colors.pink,
                        backgroundColor: Colors.grey[200],
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        labelPadding: const EdgeInsets.all(0),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = _filteredBooks[index];
                  return BookCard(book: book);
                },
                childCount: _filteredBooks.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
    );
  }
}

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookCard({super.key, required this.book});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Programming':
        return Icons.code;
      case 'Computer Science':
        return Icons.computer;
      case 'Software Engineering':
        return Icons.engineering;
      case 'Algorithms':
        return Icons.functions;
      case 'Artificial Intelligence':
        return Icons.psychology;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to book details
        },
        child: Stack(
          children: [
            // Book cover image
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(book['cover']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // Book info at bottom
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${book['pages']} pages • ${book['author']}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Rating badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[400],
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      book['rating'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Category icon
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(book['category']),
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}