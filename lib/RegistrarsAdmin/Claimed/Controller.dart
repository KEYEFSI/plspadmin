import 'dart:convert';

import 'package:plsp/RegistrarsAdmin/Claimed/Model.dart';
import 'package:plsp/common/common.dart';

import 'package:http/http.dart' as http;


class AccomplishedDocumentsController {
  final String apiUrl = '$kUrl/FMSR_GetAccomplishedDocumentsCount'; // API URL

  // Function to fetch the counts from the API
  Future<AccomplishedDocumentsCount> fetchDocumentCounts() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: kHeader,
      );

      if (response.statusCode == 200) {
        print(response.body);
        final json = jsonDecode(response.body);
        return AccomplishedDocumentsCount.fromJson(json);
      } else {
        // Handle server error by returning a default object
        print('Failed to load document counts: ${response.statusCode}');
        return AccomplishedDocumentsCount(
          totalCount: 0,
          claimedCount: 0,
          unclaimedCount: 0,
          dailyTotalCount: 0,
          dailyUnclaimedCount: 0,
          dailyClaimedCount: 0,
          dailyClaimedPercent: 0.0,
          dailyUnclaimedPercent: 0.0,
        );
      }
    } catch (error) {
      // Handle network or parsing errors and return default values
      print('Error fetching document counts: $error');
      return AccomplishedDocumentsCount(
        totalCount: 0,
        claimedCount: 0,
        unclaimedCount: 0,
        dailyTotalCount: 0,
        dailyUnclaimedCount: 0,
        dailyClaimedCount: 0,
        dailyClaimedPercent: 0.0,
        dailyUnclaimedPercent: 0.0,
      );
    }
  }
}

class DocumentController {
  final String apiUrl = '$kUrl/FMSR_AdminShowAccomplishedDocuments';

  Future<List<CollegeDocumentRequest>> fetchCollegeDocuments() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];

        // Convert JSON data to a list of CollegeDocumentRequest
        List<CollegeDocumentRequest> requests = jsonData
            .map((request) => CollegeDocumentRequest.fromJson(request))
            .toList();

        return requests;
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
        print(response.body);
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



class Document {
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

class CollegePaidDocumentController {
  final String apiUrl = '$kUrl/FMSR_CollegeUpdateDocumentToClaimed';

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