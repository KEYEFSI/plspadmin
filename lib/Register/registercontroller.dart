import 'dart:convert';
import 'package:plsp/Register/registermodel.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../common/common.dart';

class AdminController extends ChangeNotifier {
  final String apiUrl = "$kUrl/FMSR_RegisterAdmins"; // Update the URL to point to the admin registration API

  Future<bool> registerAdmin(Admin admin) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader, // Make sure kHeader contains the appropriate content-type, e.g., application/json
      body: jsonEncode(admin.toJson()), // Convert the Admin object to JSON format
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
