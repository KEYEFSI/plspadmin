import 'dart:async';
import 'dart:convert';

import 'package:plsp/FinanceAdmin/Payees/ISCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class PayeesController {
  final StreamController<PayeesData> _streamController = StreamController<PayeesData>();
  Timer? _timer;

  Stream<PayeesData> get payeesStream => _streamController.stream;

  PayeesController() {
  
    _startAutoRefresh();
  }


  void fetchPayeesData() async {
    const String apiUrl = '$kUrl/FMSR_GetPayeesStudentsAndTransactionsCount';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        PayeesData payeesData = PayeesData.fromJson(data);
        _streamController.sink.add(payeesData);
      } else {
        _streamController.sink.addError('Error: ${response.statusCode}');
      }
    } catch (e) {
      _streamController.sink.addError('Failed to fetch data: $e');
    }
  }


  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchPayeesData();
    });
  }


  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class FMSRISStudentCountController {
  final String apiUrl;

  FMSRISStudentCountController({required this.apiUrl});


  Future<ISStudentCount> fetchStudentCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetISStudentCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return ISStudentCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class FMSRISRequestCountController {
  final String apiUrl;

  FMSRISRequestCountController({required this.apiUrl});

  Future<ISRequestsCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetISRequestsCount'),
         headers: kHeader);

    if (response.statusCode == 200) {
      return ISRequestsCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
  }
}


class FMSRISTransactionCountController {
  final String apiUrl;

  FMSRISTransactionCountController({required this.apiUrl});


  Future<ISStudentTransactionCount> fetchTransactionCount() async {
    final response = await http.get(Uri.parse('$apiUrl/FMSR_GetISStudentTransactionCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return ISStudentTransactionCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class GetIS extends ChangeNotifier {
  final String baseUrl;

  GetIS(this.baseUrl);

  Future<List<ISStudent>> fetchStudentRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowPayeesRequests'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => ISStudent.fromJson(json as Map<String, dynamic>)).toList();
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
  final String apiUrl = '$kUrl/FMSR_UpdatePaidStatusPayees';

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