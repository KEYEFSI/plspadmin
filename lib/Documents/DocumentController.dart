import 'dart:convert';
import 'package:plsp/Documents/DocumentModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class FMSRDocumentCountController {
  final String apiUrl;

  FMSRDocumentCountController({required this.apiUrl});

  Future<DocumentCount> fetchRequestsCount() async {
    final response = await http
        .get(Uri.parse('$apiUrl/FMSR_CountDocuments'), headers: kHeader);

    if (response.statusCode == 200) {
      return DocumentCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load request count');
    }
  }
}

class GetDocuments extends ChangeNotifier {
  final String baseUrl;

  GetDocuments(this.baseUrl);

  // Fetch documents data from API
  Future<List<Document>> fetchStudentData() async {
    final response = await http.get(Uri.parse('$baseUrl/FMSR_AdminShowDocuments'),
        headers: kHeader); // Ensure kHeader is defined

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
      print(response.body); // To debug and check API response
      return data.map((json) => Document.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  // Refresh document data (trigger a reload)
  Future<void> refreshStudentData() async {
    await fetchStudentData(); // Fetch fresh data
    notifyListeners(); // Notify listeners for UI update
  }
}
class DocumentController extends ChangeNotifier {
  final String baseUrl;

  DocumentController(this.baseUrl);

  Future<void> deleteDocument(String documentName) async {
    final url = Uri.parse('$baseUrl/FMSR_DeleteDocument');
    final response = await http.delete(
      url,
      headers: kHeader,
      body: jsonEncode({
        'Document_Name': documentName,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Notify listeners on success
        notifyListeners();
      } else {
        // Handle API error
        throw Exception(data['error']);
      }
    } else {
      // Handle HTTP error
      throw Exception('Failed to delete document');
    }
  }
}
