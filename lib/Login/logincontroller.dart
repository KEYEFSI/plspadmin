import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plsp/common/common.dart';

class LoginController {
  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final uri = Uri.parse('$kUrl/FMSR_AdminLogin');
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(
        uri,
        headers: kHeader,
        body: body,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming your API returns a success boolean and usertype
        if (responseData['success'] == true) {
          return {
            'usertype': responseData['usertype'],
          };
        } else {
          return {
            'error': 'Login failed: ${responseData['error']}',
          };
        }
      } else {
        return {
          'error': 'Access Denied, The credentials you entered are invalid.',
        };
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'error': 'Exception occurred: $e',
      };
    }
  }
}