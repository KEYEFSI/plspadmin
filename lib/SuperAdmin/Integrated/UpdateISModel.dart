import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plsp/common/common.dart';



class FeeDetails {
  final String username;
  final String fullname;
  final String feeName;
  final double price;
  final double oldBalance;
  final double newBalance;

  FeeDetails({
    required this.username,
    required this.fullname,
    required this.feeName,
    required this.price,
    required this.oldBalance,
    required this.newBalance,
  });

  // Convert a FeeDetails object into a Map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'fee_name': feeName,
      'price': price,
      'old_balance': oldBalance,
      'new_balance': newBalance,
    };
  }
}



class FeeController {
  final String baseUrl;

  FeeController({required this.baseUrl});

  Future<bool> saveFeeDetails(FeeDetails feeDetails) async {
    final url = Uri.parse('$baseUrl/FMSR_SaveFeeDetails');
    try {
      final response = await http.post(
        url,
        headers: kHeader,
        body: json.encode(feeDetails.toJson()),
      );

      if (response.statusCode == 200) {
        // Request was successful
        return true;
      } else {
        // Handle error responses
        print('Failed to save fee details: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Error saving fee details: $e');
      return false;
    }
  }
}
