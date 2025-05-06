import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectbia/user/auth/login_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectbia/user/notif_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:projectbia/user/info/profile_pages.dart';
import 'package:projectbia/user/home/home_pages.dart';
import 'package:http/http.dart' as http;

class CustomHeader extends StatelessWidget {
  final VoidCallback? onNotifTap;
  final ValueChanged<String>? onSearch;

  const CustomHeader({super.key, this.onNotifTap, this.onSearch});

  Future<Map<String, dynamic>> fetchUserById(
    String userId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/api/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    if (token == null || JwtDecoder.isExpired(token)) {
      return {'isLoggedIn': false, 'user': null};
    }

    final decoded = JwtDecoder.decode(token);
    final userId =
        decoded['user_id'].toString(); // pastikan key sesuai dengan JWT kamu

    final userData = await fetchUserById(userId, token);

    return {'isLoggedIn': true, 'user': userData};
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;

    if (shouldLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePages()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: CircularProgressIndicator(),
          );
        }

        final isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
        final user = snapshot.data?['user'];
        final username =
            user?['name'] ?? 'Guest'; // ganti sesuai field dari API kamu
        final profileImageUrl =
            user?['profile_photo'] ??
            'https://i.pravatar.cc/150?img=3'; // fallback URL

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:
                        isLoggedIn
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePages(),
                                ),
                              );
                            }
                            : null,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              isLoggedIn ? NetworkImage(profileImageUrl) : null,
                          child: !isLoggedIn ? const Icon(Icons.person) : null,
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
                                text: '$username${isLoggedIn ? ' 👋' : ''}',
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
                  ),
                  Row(
                    children: [
                      if (onNotifTap != null && isLoggedIn)
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotifPages(),
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                        onPressed:
                            isLoggedIn
                                ? () => _handleLogout(context)
                                : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPages(),
                                    ),
                                  );
                                },
                      ),
                    ],
                  ),
                ],
              ),

              // Search Bar
              if (onSearch != null && isLoggedIn)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
