import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorSignupService {
  final String host = "http://192.168.102.56/api/reverie/";

  Future<Map<String, dynamic>> registerVendor(Map<String, dynamic> vendorData) async {
    final response = await http.post(
      Uri.parse(host + 'register_vendor.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(vendorData),
    );

    // Log the request and response for debugging
    print('Request URL: ${host + 'register_vendor.php'}');
    print('Request Body: ${json.encode(vendorData)}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register vendor');
    }
  }
}