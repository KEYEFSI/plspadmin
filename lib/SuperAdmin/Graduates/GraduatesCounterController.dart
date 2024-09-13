import 'dart:convert';

import 'package:plsp/SuperAdmin/Graduates/GraduatesCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FMSRGraduatesRequestsCountController {
  final String apiUrl;

  FMSRGraduatesRequestsCountController({required this.apiUrl});

  Future<FMSRGraduatesRequestsCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetGraduatesRequestsCount'), headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRGraduatesRequestsCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
  }
}

class FMSRGraduatesStudentCount {
  final int count;

  FMSRGraduatesStudentCount({required this.count});

  factory FMSRGraduatesStudentCount.fromJson(Map<String, dynamic> json) {
    return FMSRGraduatesStudentCount(
      count: json['count'],
    );
  }
}


class FMSR_GetGraduatesStudentTransactionCount {
  final String apiUrl;

  FMSR_GetGraduatesStudentTransactionCount({required this.apiUrl});


  Future<FMSRGraduatesTransactionCounter> fetchTransactionCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetGraduatesStudentTransactionCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRGraduatesTransactionCounter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}


class FMSRGraduatesStudentCountController {
  final String apiUrl;

  FMSRGraduatesStudentCountController({required this.apiUrl});


  Future<FMSRGraduatesStudentCount> fetchStudentCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetGraduatesStudentCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRGraduatesStudentCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class GetGraduates extends ChangeNotifier {
  final String baseUrl;

  GetGraduates(this.baseUrl);

  Future<List<StudentGrad>> fetchStudentData() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowGraduates'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => StudentGrad.fromJson(json as Map<String, dynamic>)).toList();
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

  Future<StudentGrad?> fetchStudent(String username) async {
    final response = await http.get(Uri.parse('$apiUrl?username=$username'), 
    headers: kHeader);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null && data['data'].isNotEmpty) {
        return StudentGrad.fromJson(data['data'][0]);
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
