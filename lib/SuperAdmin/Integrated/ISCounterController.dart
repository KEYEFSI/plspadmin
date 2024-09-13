import 'dart:convert';
import 'package:plsp/SuperAdmin/Integrated/ISCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class FMSRISRequestCountController {
  final String apiUrl;

  FMSRISRequestCountController({required this.apiUrl});

  Future<FMSRISRequestsCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetISRequestsCount'),
         headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRISRequestsCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
  }
}


class FMSRISTransactionCountController {
  final String apiUrl;

  FMSRISTransactionCountController({required this.apiUrl});


  Future<FMSRISStudentTransactionCount> fetchTransactionCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetISStudentTransactionCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRISStudentTransactionCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}



class FMSRISStudentCountController {
  final String apiUrl;

  FMSRISStudentCountController({required this.apiUrl});


  Future<FMSRISStudentCount> fetchStudentCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetISStudentCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRISStudentCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class GetIS extends ChangeNotifier {
  final String baseUrl;

  GetIS(this.baseUrl);

  Future<List<Student>> fetchStudentData() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowIS'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => Student.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> refreshStudentData() async {
   
      fetchStudentData();
    
  }
}

class TransactionController {
  final String apiUrl;

  TransactionController(this.apiUrl);

  Future<List<UserTransactionDetails>> getTransactions(String username) async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_UserTransactionDetails?username=$username'),
    headers: kHeader);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => UserTransactionDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}

class StudentService {
  final String apiUrl = '$kUrl/FMSR_AdminUserIS';

  Future<Student?> fetchStudent(String username) async {
    final response = await http.get(Uri.parse('$apiUrl?username=$username'), 
    headers: kHeader);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null && data['data'].isNotEmpty) {
        return Student.fromJson(data['data'][0]);
      } else {
        // Handle API response error
        return null;
      }
    } else {
      // Handle HTTP error
      return null;
    }
  }
}
