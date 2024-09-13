import 'dart:convert';

import 'package:plsp/SuperAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FMSRCollegeRequestsCountController {
  final String apiUrl;

  FMSRCollegeRequestsCountController({required this.apiUrl});

  Future<FMSRCollegeRequestCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetCollegeRequestsCount'), headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRCollegeRequestCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
  }
}

class FMSRCollegeTransactionCountController {
  final String apiUrl;

  FMSRCollegeTransactionCountController({required this.apiUrl});


  Future<FMSRCollegeTransactionCount> fetchTransactionCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetCollegeStudentTransactionCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRCollegeTransactionCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class FMSRCollegeStudentCount {
  final int count;

  FMSRCollegeStudentCount({required this.count});

  factory FMSRCollegeStudentCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeStudentCount(
      count: json['count'],
    );
  }
}

class FMSRCollegeStudentCountController {
  final String apiUrl;

  FMSRCollegeStudentCountController({required this.apiUrl});


  Future<FMSRCollegeStudentCount> fetchStudentCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetCollegeStudentCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRCollegeStudentCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class GetCollege extends ChangeNotifier {
  final String baseUrl;

  GetCollege(this.baseUrl);

  Future<List<StudentCollege>> fetchStudentData() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowCollege'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => StudentCollege.fromJson(json as Map<String, dynamic>)).toList();
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
    final response = await http.get(Uri.parse('$apiUrl/FMSR_CollegeTransactionDetails?username=$username'),
    headers: kHeader);

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => UserTransactionDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}


class StudentService {
  final String apiUrl = '$kUrl/FMSR_AdminUserCollege';

  Future<StudentCollege?> fetchStudent(String username) async {
    final response = await http.get(Uri.parse('$apiUrl?username=$username'), 
    headers: kHeader);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null && data['data'].isNotEmpty) {
        return StudentCollege.fromJson(data['data'][0]);
      } else {
        
        return null;
      }
    } else {
        
      return null;
    }
  }
}
