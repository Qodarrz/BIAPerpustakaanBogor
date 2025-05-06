// bookdetail_pages.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetailPages extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailPages({super.key, required this.book, required title, required imagePath});

  @override
  State<BookDetailPages> createState() => _BookDetailPagesState();
}

class _BookDetailPagesState extends State<BookDetailPages> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _handleBorrow() async {
    if (!_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login untuk meminjam buku ini'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.book['is_active'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku ini sedang tidak tersedia'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Peminjaman'),
        content: const Text('Apakah Anda yakin ingin meminjam buku ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Save borrowing data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final borrowedBooks = prefs.getStringList('borrowedBooks') ?? [];
      borrowedBooks.add(widget.book['code'] ?? widget.book['title']);
      await prefs.setStringList('borrowedBooks', borrowedBooks);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil meminjam buku ${widget.book['title']}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'book-cover-${widget.book['title']}',
                child: Image.asset(
                  widget.book['cover'] ?? 'assets/images/laskarpelangi.jpg',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.book['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${widget.book['author']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 16),
            // Category and Rating
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(widget.book['category'] ?? 'Unknown Category'),
                const Spacer(),
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(widget.book['rating']?.toString() ?? '0.0'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.menu_book, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${widget.book['pages']} pages'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Book Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.book['description'] ?? 'No description available',
              style: const TextStyle(
                height: 1.5,
              ),
            ),
            if (widget.book['code'] != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.code, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Code: ${widget.book['code']}'),
                ],
              ),
            ],
            if (widget.book['publisher'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Publisher: ${widget.book['publisher']}'),
                ],
              ),
            ],
            if (widget.book['year'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Year: ${widget.book['year']}'),
                ],
              ),
            ],
            if (widget.book['floor'] != null && widget.book['shelf'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Location: Floor ${widget.book['floor']}, Shelf ${widget.book['shelf']}'),
                ],
              ),
            ],
            if (widget.book['is_active'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 16,
                    color: widget.book['is_active'] ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text('Status: ${widget.book['is_active'] ? 'Available' : 'Unavailable'}'),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleBorrow,
                child: const Text(
                  'Pinjam Buku Ini',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}