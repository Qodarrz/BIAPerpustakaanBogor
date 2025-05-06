import 'package:flutter/material.dart';
// import 'package:projectbia/service/auth/auth_.dart';
import 'package:projectbia/user/navbar_pages.dart'; // Assuming CheerfulMinimalistNavBar is here
import 'package:projectbia/user/header_pages.dart'; // Assuming CustomHeader is here

class MarketPages extends StatefulWidget {
  const MarketPages({super.key});

  @override
  State<MarketPages> createState() => _MarketPagesState();
}

class _MarketPagesState extends State<MarketPages> {
  int cartItemCount = 3;
  int selectedCategoryIndex = 0;

  static const categoryAll = 'All';
  static const categoryFood = 'Food';
  static const categoryDrinks = 'Drinks';

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.all_inclusive, 'name': categoryAll},
    {'icon': Icons.local_dining, 'name': categoryFood},
    {'icon': Icons.local_drink, 'name': categoryDrinks},
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Indomie Mi Goreng',
      'price': 2500,
      'category': categoryFood,
      'image': 'assets/images/makanan1.png',
      'isFavorite': true,
    },
    {
      'name': 'Aqua 600ml',
      'price': 3000,
      'category': categoryDrinks,
      'image': 'assets/images/makanan2.png',
      'isFavorite': false,
    },
    {
      'name': 'Pocari Sweat',
      'price': 7500,
      'category': categoryDrinks,
      'image': 'assets/images/makanan3.png',
      'isFavorite': false,
    },
  ];

  final List<String> promoBanners = [
    'assets/images/promo1.jpg',
    'assets/images/promo2.jpg',
    'assets/images/promo3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        selectedCategoryIndex == 0
            ? products
            : products
                .where(
                  (p) =>
                      p['category'] ==
                      categories[selectedCategoryIndex]['name'],
                )
                .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        // Tambahin SafeArea di sini
        child: Column(
          children: [
            CustomHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPromoCarousel(),
                    _buildCategoryList(),
                    _buildProductGrid(filteredProducts),
                  ],
                ),
              ),
            ),
            CheerfulMinimalistNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: promoBanners.length,
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  promoBanners[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final isSelected = selectedCategoryIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedCategoryIndex = index),
              child: Container(
                width: 80,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 0,
                  right: index == categories.length - 1 ? 16 : 8,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.orange[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color:
                              isSelected ? Colors.orange : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        categories[index]['icon'],
                        color: isSelected ? Colors.orange : Colors.grey[600],
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categories[index]['name'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.orange : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildProductCard(items[index]),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Gambar produk sebagai background
          Image.asset(
            product['image'],
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Overlay teks di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rp${product['price']}',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
