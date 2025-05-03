// lib/widgets/custom_header.dart

import 'package:flutter/material.dart';
import 'package:projectbia/pages/auth/login_pages.dart';

class CustomHeader extends StatelessWidget {
  final String username;
  final VoidCallback? onLogout;
  final VoidCallback? onNotifTap;
  final ValueChanged<String>? onSearch;

  const CustomHeader({
    super.key,
    required this.username,
    this.onLogout,
    this.onNotifTap,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Profile + Greeting
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3', // Ganti sesuai foto kamu
                    ),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Hello,\n',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '$username! 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right: Notification + Logout Icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: onNotifTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPages()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search something...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: onSearch,
          ),
        ],
      ),
    );
  }
}
