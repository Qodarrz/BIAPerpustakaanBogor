import 'package:flutter/material.dart';
import 'package:projectbia/admin/dashboard/alldata_pages.dart';
import 'package:projectbia/admin/pages/bookset_pages.dart';
import 'package:projectbia/admin/pages/productset_pages.dart';
import 'package:projectbia/admin/pages/recomm_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectbia/user/home/home_pages.dart';

class AdminDrawer extends StatelessWidget {
  final String currentPage;

  const AdminDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Admin Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'All Data Pages',
            isSelected: currentPage == 'all',
            page: AllDataPages(),
          ),
          _buildDrawerItem(
            context,
            title: 'Book Set Pages',
            isSelected: currentPage == 'book',
            page: BookSetPages(),
          ),
          _buildDrawerItem(
            context,
            title: 'Product Set Pages',
            isSelected: currentPage == 'product',
            page: ProductSetPages(),
          ),
          _buildDrawerItem(
            context,
            title: 'Recommendation Pages',
            isSelected: currentPage == 'recomm',
            page: RecommPages(),
          ),
          const Divider(), // Add a divider before logout
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required Widget page,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          Navigator.pop(context); // just close drawer
        }
      },
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      onTap: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Konfirmasi Logout'),
                content: const Text('Yakin ingin keluar dari akun?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );

        if (shouldLogout ?? false) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('jwt');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePages()),
            (route) => false,
          );
        }
      },
    );
  }
}
