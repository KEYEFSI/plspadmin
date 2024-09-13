import 'dart:convert';
import 'package:plsp/SuperAdmin/Admin/AdminModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/common.dart';

class AdminController extends ChangeNotifier {
  final String apiUrl = "$kUrl/FMSR_RegisterAdmin"; // Replace with your API URL

  Future<bool> registerAdmin(AdminAccount admin) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode == 200) {
      return true; // Registration successful
    } else {
      // Handle error responses here
      print('Failed to register admin: ${response.body}');
      return false;
    }
  }
}

class FinanceAdminController extends ChangeNotifier {
  final String baseUrl;

  FinanceAdminController(this.baseUrl);

  Future<List<FinanceAdmin>> fetchFinanceAdmins() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowFinance'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => FinanceAdmin.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
 
}

class RegistrarAdminController extends ChangeNotifier {
  final String baseUrl;

  RegistrarAdminController(this.baseUrl);

  Future<List<RegistrarAdmin>> fetchRegistrarAdmins() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowRegistrar'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => RegistrarAdmin.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
 
}

class DeleteController extends ChangeNotifier {
  String apiUrl = "$kUrl/FMSR_DeleteAdmin"; 

  // Method to delete an admin by username
  Future<void> deleteAdmin(String username) async {
    try {
      final url = Uri.parse('$apiUrl/$username');

      // Send DELETE request to the server
      final response = await http.delete(url,
      headers: kHeader);

      if (response.statusCode == 200) {
        // Parse the response
        final responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          print("Admin deleted successfully.");
        } else {
          throw Exception("Failed to delete admin: ${responseBody['error']}");
        }
      } else {
        throw Exception("Failed to delete admin. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error deleting admin: $error");
      rethrow;  // Optionally rethrow for further error handling in the UI
    }
  }
}