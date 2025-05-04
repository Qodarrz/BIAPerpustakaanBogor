import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class AuthService {
  static const String _baseUrl = 'http://localhost:4500/api'; // Ganti sesuai API kamu

  // Fungsi login
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Simpan token jika perlu pakai shared_preferences
      final data = jsonDecode(response.body);
      final token = data['token']; // Misalnya token ada di dalam respons JSON
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token); // Simpan token ke shared_preferences
      print("Login berhasil: $data");
      return true;
    }

    return false;
  }

  // Fungsi logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Hapus token saat logout
    print("Logout berhasil");
  }
}
