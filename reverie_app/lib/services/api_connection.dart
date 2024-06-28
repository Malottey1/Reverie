import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConnection {
  final String host = "http://192.168.100.61/api/reverie/";

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse(host + 'register.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );

    // Print the request and response for debugging
    print('Request URL: ${host + 'register.php'}');
    print('Request Body: ${json.encode(user)}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}