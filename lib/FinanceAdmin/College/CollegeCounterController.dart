import 'dart:convert';



import 'package:plsp/FinanceAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class FMSRCollegeRequestCountController {
  final String apiUrl;

  FMSRCollegeRequestCountController({required this.apiUrl});

  Future<FMSRCollegeRequestCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_GetCollegeRequestsCount'),
         headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRCollegeRequestCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
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

class GetCollege extends ChangeNotifier {
  final String baseUrl;

  GetCollege(this.baseUrl);

  Future<List<CollegeRequest>> fetchStudentRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowCollegeRequests'),
        headers: kHeader);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body);
      return data.map((json) => CollegeRequest.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> refreshStudentData() async {
   
      fetchStudentRequests();
    
  }
}



class StudentService {
  final String apiUrl = '$kUrl/FMSR_AdminUserCollege';

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

class UserRequestController {
  final String apiUrl = '$kUrl/FMSR_GetCollegeRequests';

  Future<List<UserRequest>?> fetchRequests(String username, String date) async {
    final response = await http.get(
      Uri.parse('$apiUrl?username=$username&date=$date'),
      headers: kHeader,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);

      if (data is List && data.isNotEmpty) {
        return List<UserRequest>.from(
          data.map((item) => UserRequest.fromJson(item)),
        );
      } else {
       
        return null;
      }
    } else {
    
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

class CollegeTransactionController {
  final String apiUrl = "$kUrl/FMSR_CollegeTransactions";

  // Simplified method to submit a CollegeTransaction
  Future<bool> submitTransaction(CollegeTransaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(transaction.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      print("Error submitting transaction: $error");
      return false;
    }
  }
}

class UpdateCollegeRequestController with ChangeNotifier {
  static const String apiUrl = '$kUrl/FMSR_UpdatePaidStatusCollege'; // Update with your API URL
  
  // Method to send a request to update paid status of college requests
  Future<http.Response> updateCollegeRequests(List<UserRequest> requests) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode({
        'documents': requests.map((req) => req.toJson()).toList(),
      }),
    );

    return response; // Return the response for further processing
  }
}

class UserPaidDocumentController extends ChangeNotifier {
  static const String apiUrl = '$kUrl/FMSR_insertuserCollegePaidDocuments'; 

  final ORNumberController orNumberController = ORNumberController();

  Future<bool> insertDocuments(List<UserPaidDocument> documents) async {
    
    final currentORString = await orNumberController.fetchCurrentORNumber();
    final int currentOR = (int.tryParse(currentORString) ?? 0);
    final invoiceNumber = currentOR; 

    final headers = kHeader;

    // Convert the documents to JSON with the new invoice number
    final List<Map<String, dynamic>> jsonDocuments = documents.map((doc) {
      return {
        'username': doc.username,
        'documentName': doc.documentName,
        'price': doc.price,
        'date': doc.date?.toIso8601String(),
        'requirements1': doc.requirements1,
        'requirements2': doc.requirements2,
        'invoice': invoiceNumber
      };
    }).toList();

    final body = jsonEncode({'documents': jsonDocuments});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        notifyListeners(); // Notify listeners on success
        return true;
      } else {
        print('Error inserting documents: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}