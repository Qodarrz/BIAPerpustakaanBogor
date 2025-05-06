import 'package:flutter/material.dart';

// Import semua halaman yang akan digunakan
import 'package:projectbia/user/home/home_pages.dart';
import 'package:projectbia/user/book/book_pages.dart';
import 'package:projectbia/user/market/market_pages.dart';
import 'package:projectbia/user/about/about_pages.dart';

class AppRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String market = '/market';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => HomePages(),
          settings: settings,
        );
      case library:
        return MaterialPageRoute(
          builder: (_) => BookPages(),
          settings: settings,
        );
      case market:
        return MaterialPageRoute(
          builder: (_) => MarketPages(),
          settings: settings,
        );
      case about:
        return MaterialPageRoute(
          builder: (_) => AboutPages(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => HomePages(),
          settings: const RouteSettings(name: home),
        );
    }
  }
}