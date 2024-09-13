import 'dart:convert';
import 'package:plsp/RegistrarsAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FMSRCollegeStudentCountController {
  final String apiUrl;

  FMSRCollegeStudentCountController({required this.apiUrl});

  Future<FMSRCollegeStudentCount> fetchStudentCount() async {
    final response = await http.get(
        Uri.parse('$apiUrl/FMSR_GetCollegeStudentCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return FMSRCollegeStudentCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class FMSRCollegePendingCountController {
  final String apiUrl;

  FMSRCollegePendingCountController({required this.apiUrl});

  Future<PendingCount> fetchTransactionCount() async {
    final response = await http.get(
        Uri.parse('$apiUrl/FMSR_GetCollegeStudentPendingCount'),
        headers: kHeader);

    if (response.statusCode == 200) {
      return PendingCount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student count');
    }
  }
}

class AccomplishedCountController {


  Future<AccomplishedCount> fetchAccomplishedCount() async {
    final response = await http.get(Uri.parse('$kUrl/FMSR_GetCollegeStudentAccomplishedCount'),
  headers:  kHeader);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(response.body);
      return AccomplishedCount.fromJson(json);
    } else {
      throw Exception('Failed to load accomplished count');
    }
  }
}

class AdminShowCollegeDocumentsController {
  final String apiUrl = '$kUrl/FMSR_AdminShowCollegeDocumentsReq';

  Future<List<CollegeDocumentRequest>> fetchCollegeDocuments() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonData = json.decode(response.body)['data'];

        List<CollegeDocumentRequest> documents = jsonData
            .map((doc) => CollegeDocumentRequest.fromJson(doc))
            .toList();

        return documents;
      } else {
        throw Exception('Failed to load college documents');
      }
    } catch (e) {
      throw Exception('Error fetching college documents: $e');
    }
  }
}

class CourseController {
  // Fetch courses from the API
  Future<List<Course>> fetchCourses() async {
    try {
      final response =
          await http.get(Uri.parse('$kUrl/FMSR_GetCourses'), headers: kHeader);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return List<Course>.from(
            data.map((item) => Course.fromJson(item)),
          );
        } else {
          return [];
        }
      } else {
        // Handle non-200 status codes if needed
        print('Failed to load courses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle error, for example log it or show a message
      print('Error fetching courses: $e');
      return [];
    }
  }
}


class DocumentController {
  Future<List<DocumentList>> fetchDocuments() async {
    final url = Uri.parse('$kUrl/FMSR_ShowDocuments');
    final response = await http.get(url,
    headers: kHeader);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DocumentList.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }
}

class CollegeAccomplishedDocumentsController {
  final String apiUrl = "$kUrl/FMSR_CollegeAccomplishedDocuments";

  // Function to send data to the server
  Future<bool> submitCollegeDocument(CollegeAccomplishedDocument document) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(document.toJson()), // Converting model to JSON before sending
      );

      if (response.statusCode == 200) {
        // Successfully submitted data
        return true;
      } else {
        // Handle error response
        debugPrint("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception: $e");
      return false;
    }
  }
}


class CollegePaidDocumentController {
  final String apiUrl = '$kUrl/FMSR_CollegeUpdateDocumentToClaimable';

  
  Future<bool> updateCollegePaidDocumentToClaimable(CollegePaidDocument document) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(document.toJson()),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        return true;
      } else if (response.statusCode == 404) {
        // Document not found
        print('Document not found');
        return false;
      } else {
        // Other error
        print('Failed to update document: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating document: $e');
      return false;
    }
  }
}
