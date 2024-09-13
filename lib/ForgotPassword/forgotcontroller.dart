import 'dart:convert';
import 'package:plsp/ForgotPassword/forgotmodel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ForgotPasswordController extends ChangeNotifier {
  final String apiUrl = "$kUrl/FMSR_ForgotPasswordAdmin";

  // Function to send the password reset request
  Future<ForgotPasswordModel> sendPasswordResetRequest(String username) async {
    try {
      // Make POST request to the forgot password API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode({'username': username}),
      );

      // Handle success response
      if (response.statusCode == 200) {
        return ForgotPasswordModel.fromJson(jsonDecode(response.body));
      } else {
        // Handle error response
        final errorResponse = jsonDecode(response.body);
        return ForgotPasswordModel(
          message: errorResponse['message'] ?? 'An error occurred',
          error: errorResponse['error'],
        );
      }
    } catch (e) {
      // Handle network or unexpected errors
      return ForgotPasswordModel(
        message: 'Failed to send password reset request',
        error: e.toString(),
      );
    }
  }
}
class VerifyTokenController {
  final String apiUrl = "$kUrl/FMSR_VerifyToken"; // Replace with your actual API URL

  Future<VerifyTokenResponse> verifyToken(String token) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      return VerifyTokenResponse(error: errorResponse['error']);
    }
  }
}

class UpdatePasswordController {
  final String apiUrl = "$kUrl/FMSR_UpdateAdminPassword"; // Updated API URL

  Future<UpdatePasswordResponse> updatePassword(String username, String newPassword) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode({'username': username, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return UpdatePasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      return UpdatePasswordResponse(error: errorResponse['error']);
    }
  }
}
