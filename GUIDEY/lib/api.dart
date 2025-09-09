import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerUser(String username, String email, String passwordHash) async {
  final url = Uri.parse("http://localhost:80"); // غيريها باللينك بتاعك

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "username": username,
      "email": email,
      "password_hash": passwordHash,
    }),
  );

  if (response.statusCode == 200) {
    print("✅ User registered successfully: ${response.body}");
  } else {
    print("❌ Failed to register: ${response.statusCode} - ${response.body}");
  }
}