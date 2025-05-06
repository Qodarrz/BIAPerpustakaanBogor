import 'package:flutter/material.dart';
import 'package:projectbia/user/navbar_pages.dart';
import 'package:projectbia/user/header_pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutPages extends StatefulWidget {
  const AboutPages({super.key});

  @override
  _AboutPagesState createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<String> _sliderImages = [
    'assets/images/perpus1.jpg',
    'assets/images/perpus2.png',
    'assets/images/perpus3.jpg',
  ];

  final List<Map<String, dynamic>> _awards = [
    {
      'title': 'Best Public Library 2023',
      'description': 'Awarded by Ministry of Education for excellent service',
      'icon': Icons.star,
    },
    {
      'title': 'Green Library Certification',
      'description': 'Recognized for sustainable practices in library management',
      'icon': Icons.eco,
    },
    {
      'title': 'Digital Innovation Award',
      'description': 'For implementing cutting-edge digital services',
      'icon': Icons.bolt,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll the image slider
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _sliderImages.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: CustomHeader()),
            
            // Image Slider Section with Parallax effect
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _sliderImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              _sliderImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ).animate().scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 20,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _sliderImages.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.white,
                          spacing: 5,
                          expansionFactor: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero Section with Logo
                    _buildHeroSection(),
                    const SizedBox(height: 32),
                    
                    // Library Stats with animation
                    _buildStatsSection(),
                    const SizedBox(height: 40),
                    
                    // About Section with Image
                    _buildAboutSection(),
                    const SizedBox(height: 40),
                    
                    // Awards Section
                    _buildAwardsSection(),
                    const SizedBox(height: 40),
                    
                    // Contact Info
                    _buildContactSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CheerfulMinimalistNavBar(),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.library_books,
            size: 50,
            color: Colors.white,
          ),
        ).animate().scale(duration: 500.ms).fadeIn(),
        const SizedBox(height: 16),
        const Text(
          'Bogor Public Library',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),
        const Text(
          'Established in 1952, Bogor Public Library has been serving the community for over 70 years. We provide access to knowledge, information, and works of imagination through a wide range of resources and services.',
          style: TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('50K+', 'Books', Icons.menu_book),
          _buildStatItem('10K', 'Members', Icons.people),
          _buildStatItem('24/7', 'Digital Access', Icons.cloud),
        ],
      ).animate().slideX(duration: 500.ms),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        const Text(
          'About Our Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideY(duration: 300.ms),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/perpus4.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ).animate().scale(delay: 200.ms),
        const SizedBox(height: 16),
        const Text(
          'Located in the heart of Bogor, our library occupies a historic building that combines traditional architecture with modern facilities. We offer quiet reading spaces, study rooms, computer labs, and a children\'s area to serve all members of our community.',
          style: TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildAwardsSection() {
    return Column(
      children: [
        const Text(
          'Our Awards & Recognitions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._awards.map((award) => _buildAwardCard(award)).toList(),
      ],
    );
  }

  Widget _buildAwardCard(Map<String, dynamic> award) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  award['icon'] as IconData,
                  color: Colors.amber.shade800,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      award['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      award['description']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (100 * _awards.indexOf(award)).ms).slideX(
      begin: -0.5,
      duration: 300.ms,
      curve: Curves.easeOut,
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        const Text(
          'Visit Us',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactTile(
          icon: Icons.location_on,
          title: 'Jl. Raya Pajajaran No. 25, Bogor',
          color: Colors.red,
        ),
        _buildContactTile(
          icon: Icons.phone,
          title: '(0251) 8321234',
          color: Colors.green,
        ),
        _buildContactTile(
          icon: Icons.email,
          title: 'info@bogorlibrary.go.id',
          color: Colors.blue,
        ),
        _buildContactTile(
          icon: Icons.access_time,
          title: 'Monday-Friday: 8AM-8PM',
          subtitle: 'Weekends: 9AM-5PM',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    ).animate().fadeIn().slideX(
      begin: 0.2,
      duration: 300.ms,
      curve: Curves.easeOut,
    );
  }
}