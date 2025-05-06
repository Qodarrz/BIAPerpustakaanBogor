import 'package:flutter/material.dart';
import 'package:projectbia/user/routes/route_app.dart';

class CheerfulMinimalistNavBar extends StatefulWidget {
  const CheerfulMinimalistNavBar({super.key});

  @override
  State<CheerfulMinimalistNavBar> createState() =>
      _CheerfulMinimalistNavBarState();
}

class _CheerfulMinimalistNavBarState extends State<CheerfulMinimalistNavBar>
    with TickerProviderStateMixin, RouteAware {
  int _selectedIndex = 0;
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _textControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _textAnimations;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      label: "Home",
      color: Colors.orange,
      route: AppRoutes.home, // Changed from 'HomePages' to '/home'
    ),
    NavItem(
      icon: Icons.search,
      label: "Library",
      color: Colors.pink,
      route: AppRoutes.library, // Changed from '/book' to match AppRoutes
    ),
    NavItem(
      icon: Icons.favorite_border,
      label: "Market",
      color: Colors.purple,
      route: AppRoutes.market,
    ),
    NavItem(
      icon: Icons.person_outline,
      label: "About",
      color: Colors.blue,
      route: AppRoutes.about,
    ),
  ];
  @override
  void initState() {
    super.initState();

    _scaleControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _textControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _scaleAnimations = List.generate(
      _navItems.length,
      (index) => Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: _scaleControllers[index],
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        ),
      ),
    );

    _textAnimations = List.generate(
      _navItems.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textControllers[index], curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      _updateSelectedIndex(route.settings.name);
    }
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateSelectedIndex(String? routeName) {
    if (routeName == null) return;

    // Find the best matching route
    final index = _navItems.indexWhere((item) {
      // Handle direct matches
      if (item.route == routeName) return true;

      // Handle cases where route might have parameters
      final routeUri = Uri.parse(routeName);
      final itemUri = Uri.parse(item.route);
      return routeUri.path == itemUri.path;
    });

    if (index != -1 && index != _selectedIndex) {
      setState(() {
        // Hide text for previously selected item
        _textControllers[_selectedIndex].reverse();
        _scaleControllers[_selectedIndex].reverse();

        _selectedIndex = index;

        // Show text for newly selected item
        _textControllers[index].forward();
        _scaleControllers[index].forward();
      });
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      // Animate out previous selection
      _textControllers[_selectedIndex].reverse();
      _scaleControllers[_selectedIndex].reverse();

      _selectedIndex = index;

      // Animate in new selection
      _textControllers[index].forward();
      _scaleControllers[index].forward();
    });

    Navigator.pushNamed(context, _navItems[index].route).then((_) {
      if (mounted) {
        _scaleControllers[index].reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimations[index],
              child: Icon(
                item.icon,
                size: 28, // Larger icon size
                color: isSelected ? item.color : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 24 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            FadeTransition(
              opacity: _textAnimations[index],
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? item.color : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
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
