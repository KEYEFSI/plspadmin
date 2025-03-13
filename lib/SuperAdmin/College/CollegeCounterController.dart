import 'dart:async';
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
  final String apiUrl = "$kUrl/FMSR_AdminShowCollege";
  final StreamController<List<StudentCollege>> _studentStreamController =
      StreamController<List<StudentCollege>>.broadcast();

  // Stream to listen to data changes
  Stream<List<StudentCollege>> get studentStream => _studentStreamController.stream;

  Timer? _timer;

  // Start fetching student data periodically
  void startFetching() {
    _timer = Timer.periodic(Duration(seconds: 10), (_) async {
      await _fetchStudentData(); // Periodically fetch the data
    });
  }

  // Fetch student data from the API
  Future<void> _fetchStudentData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
        print(response.body);
        
        // Add the fetched data to the stream
        _studentStreamController.add(
          data.map((json) => StudentCollege.fromJson(json as Map<String, dynamic>)).toList(),
        );
      } else {
        _studentStreamController.addError('Failed to load students, status code: ${response.statusCode}');
      }
    } catch (error) {
      // If there is an error, add an error to the stream
      _studentStreamController.addError('Error fetching student data: $error');
    }
  }

  // Refresh the student data manually (called from outside)
  Future<void> refreshStudentData() async {
    await _fetchStudentData(); // Fetch student data immediately
  }

  // Dispose the stream controller and cancel the periodic fetch timer
  void dispose() {
    _timer?.cancel();
    _studentStreamController.close();
    super.dispose();
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
