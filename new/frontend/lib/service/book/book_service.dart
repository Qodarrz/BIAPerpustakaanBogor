import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://localhost:4500/api'; // ganti sesuai API kamu

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Simpan token jika perlu pakai shared_preferences
      final data = jsonDecode(response.body);
      print("Login berhasil: $data");
      return true;
    }

    return false;
  }
}
