import 'package:flutter/material.dart';

class CheerfulMinimalistNavBar extends StatefulWidget {
  const CheerfulMinimalistNavBar({super.key});

  @override
  State<CheerfulMinimalistNavBar> createState() =>
      _CheerfulMinimalistNavBarState();
}

class _CheerfulMinimalistNavBarState extends State<CheerfulMinimalistNavBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      label: "Home",
      color: Colors.orange,
      route: '/home',
    ),
    NavItem(
      icon: Icons.search,
      label: "Library",
      color: Colors.pink,
      route: '/book',
    ),
    NavItem(
      icon: Icons.favorite_border,
      label: "Market",
      color: Colors.purple,
      route: '/market',
    ),
    NavItem(
      icon: Icons.person_outline,
      label: "About",
      color: Colors.blue,
      route: '/about',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    _animations = List.generate(
      _navItems.length,
      (index) => Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: _animationControllers[index],
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    for (var controller in _animationControllers) {
      controller.reverse();
    }

    _animationControllers[index].forward();

    // Navigasi ke halaman berdasarkan route
    Navigator.pushNamed(context, _navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _navItems.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animations[index],
            child: Icon(
              item.icon,
              size: 24,
              color: isSelected ? item.color : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 20 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? item.color : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}
