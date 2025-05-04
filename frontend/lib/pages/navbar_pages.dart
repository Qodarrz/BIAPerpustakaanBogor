import 'package:flutter/material.dart';

class CheerfulMinimalistNavBar extends StatefulWidget {
  const CheerfulMinimalistNavBar({super.key});

  @override
  State<CheerfulMinimalistNavBar> createState() =>
      _CheerfulMinimalistNavBarState();
}

class _CheerfulMinimalistNavBarState extends State<CheerfulMinimalistNavBar>
    with TickerProviderStateMixin, RouteAware {
  int _selectedIndex = 0;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  bool _isAnimating = false;
  DateTime? _lastTapTime;
  late RouteObserver<PageRoute> _routeObserver;

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
    _routeObserver = RouteObserver<PageRoute>();
    
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
          reverseCurve: Curves.easeIn,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      _routeObserver.subscribe(this, route as PageRoute<dynamic>);
      _updateSelectedIndex(route.settings.name);
    }
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedIndex(ModalRoute.of(context)?.settings.name);
  }

  @override
  void didPopNext() {
    _updateSelectedIndex(ModalRoute.of(context)?.settings.name);
  }

  void _updateSelectedIndex(String? routeName) {
    if (routeName == null) return;
    
    final index = _navItems.indexWhere((item) => item.route == routeName);
    if (index != -1 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _onItemTapped(int index) async {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastTapTime = now;

    if (_isAnimating || _selectedIndex == index) return;

    setState(() {
      _isAnimating = true;
    });

    // Reset all animations first
    await Future.wait(
      _animationControllers.map((controller) => controller.reverse()),
    );

    // Play the selected animation
    await _animationControllers[index].forward();

    // Navigate after animation completes
    try {
      await Navigator.pushNamed(context, _navItems[index].route);
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isAnimating ? 0.05 : 0.1),
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

    return IgnorePointer(
      ignoring: _isAnimating,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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