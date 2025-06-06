// lib/controllers/admin_profile_controller.dart


import 'package:plsp/FinanceAdmin/FinanceAdminNav/ProfileModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plsp/common/common.dart';

class FinanceAdminProfileController {
  final String apiUrl = '$kUrl/FMSR_AdminShowProfile';

  Future<AdminFinanceProfile?> fetchAdminProfile(String username) async {
    final response = await http.get(Uri.parse('$apiUrl?username=$username'),
    headers: kHeader);

    if (response.statusCode == 200) {
      return AdminFinanceProfile.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      print('Admin not found');
      return null;
    } else {
      print('Failed to load admin profile');
      return null;
    }
  }
}
