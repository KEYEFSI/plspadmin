import 'dart:convert';

import 'package:plsp/FinanceAdmin/Admin/AdminModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/common.dart';

class AdminProfileController {

  AdminProfileController();

  Future<AdminProfileModel?> fetchAdminProfile(String username) async {
    final response = await http.get(Uri.parse('$kUrl/FMSR_AdminUserProfile?username=$username'),
    headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return AdminProfileModel.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${response.body}');
    } else if (response.statusCode == 404) {
      throw Exception('Admin not found');
    } else {
      throw Exception('Failed to load admin profile');
    }
  }
}


class AdminUpdateController {
  final String apiUrl = '$kUrl/FMSR_UpdateAdmin'; // Replace with your API URL

  Future<void> updateAdmin(AdminUpdateModel model) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: json.encode(model.toJson()),
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['error'] ?? 'Failed to update admin');
    }
  }
}

class AdminUpdateProfileController {
  final String apiUrl = '$kUrl/FMSR_UpdateAdminProfile'; // Replace with your API URL

  Future<void> updateAdminProfile(UpdateProfileModel model, String? profileImagePath) async {
    final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

    // Add headers
    request.headers.addAll(kHeader);

    // Add fields
    request.fields['username'] = model.username;
    if (model.fullname != null) request.fields['fullname'] = model.fullname!;
    if (model.firstName != null) request.fields['First_Name'] = model.firstName!;
    if (model.middleName != null) request.fields['Middle_Name'] = model.middleName!;
    if (model.lastName != null) request.fields['Last_Name'] = model.lastName!;
    if (model.usertype != null) request.fields['usertype'] = model.usertype!;
    if (model.address != null) request.fields['address'] = model.address!;
    if (model.number != null) request.fields['number'] = model.number!;
    if (model.birthday != null) request.fields['birthday'] = model.birthday!.toIso8601String();

    // Add profile image if provided
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', profileImagePath));
    }

    // Send request
    final response = await request.send();

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      final errorResponse = json.decode(responseBody);
      throw Exception(errorResponse['error'] ?? 'Failed to update admin profile');
    }
  }
}