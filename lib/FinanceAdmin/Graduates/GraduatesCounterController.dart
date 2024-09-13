import 'dart:convert';


import 'package:plsp/FinanceAdmin/Graduates/GraduatesCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FMSRGraduatesRequestCountController {
  final String apiUrl;

  FMSRGraduatesRequestCountController({required this.apiUrl});

  Future<FMSRGraduatesRequestCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetGraduatesRequestsCount'),
         headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRGraduatesRequestCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
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

class FMSRGraduatesTransactionCountController {
  final String apiUrl;

  FMSRGraduatesTransactionCountController({required this.apiUrl});


  Future<FMSRGraduatesTransactionCount> fetchTransactionCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetGraduatesStudentTransactionCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRGraduatesTransactionCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class GetGraduates extends ChangeNotifier {
  final String baseUrl;

  GetGraduates(this.baseUrl);

  Future<List<GraduatesStudent>> fetchStudentRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowGraduatesRequests'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => GraduatesStudent.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> refreshStudentData() async {
   
      fetchStudentRequests();
    
  }
}



class StudentService {
  final String apiUrl = '$kUrl/FMSR_AdminUserIS';

  Future<SelectedStudent?> fetchStudent(String username) async {
    final response = await http.get(Uri.parse('$apiUrl?username=$username'), 
    headers: kHeader);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      if (data['success'] && data['data'] != null && data['data'].isNotEmpty) {
        return SelectedStudent.fromJson(data['data'][0]);

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

class ORNumberController extends ChangeNotifier {
  Future<String> fetchCurrentORNumber() async {
    final response = await http.get(Uri.parse('$kUrl/FMSR_CurrentORNumber'),
    headers: kHeader);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current_or_number'].toString() ?? 'No OR number found';
    } else if (response.statusCode == 404) {
      return 'No OR number found';
    } else {
      throw Exception('Failed to load OR number');
    }
  }
}

class TransactionController {
  Future<bool> saveTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('$kUrl/FMSR_Transactions'),
      headers:kHeader,
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } else {
      return false;
    }
  }

  Future<String> fetchCurrentORNumber() async {
    // Implementation for fetching the current OR number
    return '0'; // Placeholder
  }
}

class UpdatePaidStatusController {
  final String apiUrl = '$kUrl/FMSR_UpdatePaidStatusGraduates';

  Future<void> updatePaidStatus(UpdatePaidStatusRequest request) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        print('Paid status updated successfully');
      } else {
        print('Failed to update paid status: ${responseData['error']}');
      }
    } else {
      print('Failed to update paid status: Server error');
    }
  }
}