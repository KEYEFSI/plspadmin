import 'dart:async';
import 'dart:convert';

import 'package:plsp/SuperAdmin/Payees/GraduatesCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddFeeService {
  final String apiUrl = "$kUrl/FMSR_ViewFees"; // Replace with your actual API URL

  final StreamController<List<AddFeeModel>> _streamController =
      StreamController<List<AddFeeModel>>.broadcast();
  Timer? _timer;

  Stream<List<AddFeeModel>> get feeStream => _streamController.stream;

  // Function to fetch fees from the API
  Future<void> fetchFees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl),
       headers: kHeader);

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body)['fees'] ?? [];
        final List<AddFeeModel> fees = responseData
            .map((data) => AddFeeModel.fromJson(data))
            .toList();

        // Add the fees data to the stream
        _streamController.add(fees);
      } else {
        // Handle non-200 responses by adding an error to the stream
        _streamController.addError('Failed to load fees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Add an error to the stream if something goes wrong
      _streamController.addError('Error fetching fees: $e');
    }
  }

  // Start periodic fee fetching
  void startFetching({Duration interval = const Duration(seconds: 5)}) {
    fetchFees(); // Initial fetch
    _timer = Timer.periodic(interval, (_) => fetchFees());
  }

  // Stop periodic fee fetching
  void stopFetching() {
    _timer?.cancel();  // Cancel the timer if fetching is stopped
    _streamController.close(); // Close the stream controller
  }
}


class DeleteFeeController {
  Future<bool> deleteFee(String feeName) async {
    final url = "$kUrl/FMSR_DeleteFee";  // Replace with your actual API URL
    final response = await http.delete(
      Uri.parse(url),
      headers: kHeader,
      body: jsonEncode({"feeName": feeName}),
    );

    if (response.statusCode == 200) {
      return true; // Fee deleted successfully
    } else {
      return false; // Error deleting fee
    }
  }
}
class AddFeeController {
  final String apiUrl = "$kUrl/FMSR_AddFee"; // Replace with your actual API URL

  Future<bool> addFee(AddFeeModel fee) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        
     
        body: jsonEncode(fee.toJson()),
      );

      if (response.statusCode == 201) {
        print("Fee added successfully: ${response.body}");
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'] ?? 'Unknown error occurred';
        print("Failed to add fee: $errorMessage");
        return false;
      }
    } catch (e) {
      print("Error while adding fee: $e");
      return false;
    }
  }
}

class FeesController {
  final String apiUrl = '$kUrl/FMSR_AdminShowFees'; // Replace with your actual API URL

  // Method to fetch fees from the API
  Future<List<Fee>> fetchFees() async {
    final response = await http.get(Uri.parse(apiUrl),
    headers: kHeader);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      // Convert the list of JSON objects into a list of Fee objects
      return data.map((json) => Fee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load fees');
    }
  }
}


 


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
  final String apiUrl = "$kUrl/FMSR_AdminShowPayees"; // Assuming kUrl is predefined

  // StreamController to manage the stream of student data
  final StreamController<List<Student>> _studentStreamController =
      StreamController<List<Student>>.broadcast();

  // Stream to listen to data changes
  Stream<List<Student>> get studentStream => _studentStreamController.stream;

  GetGraduates();

  // Fetch student data and add it to the stream
  Future<void> fetchStudentData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
        print(response.body);

        // Add the fetched data to the stream
        _studentStreamController.add(
          data.map((json) => Student.fromJson(json as Map<String, dynamic>)).toList(),
        );
      } else {
        throw Exception('Failed to load graduates');
      }
    } catch (error) {
      // If there is an error, add an error to the stream
      _studentStreamController.addError('Error fetching graduate data: $error');
    }
  }

  // Refresh the student data manually (called from outside)
  Future<void> refreshStudentData() async {
    await fetchStudentData(); // Fetch student data immediately
  }

  // Dispose the stream controller when it's no longer needed
  void dispose() {
    _studentStreamController.close();
    super.dispose();
  }
}
class TransactionController {
  final String apiUrl;

  TransactionController(this.apiUrl);

  Future<List<TransactionData>> getTransactionDataList(String username) async {
    final response = await http.get(
      Uri.parse('$apiUrl/FMSR_TransactionDataList?username=$username'),
      headers: kHeader,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => TransactionData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transaction data');
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


class PayeesController {
  final StreamController<PayeesData> _streamController = StreamController<PayeesData>();
  Timer? _timer;

  Stream<PayeesData> get payeesStream => _streamController.stream;

  PayeesController() {
    // Start auto-refresh when the controller is created
    _startAutoRefresh();
  }

  // Fetches data from the API
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

  // Starts the auto-refresh every 3 seconds
  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchPayeesData();
    });
  }

  // Dispose of the timer and stream controller
  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}