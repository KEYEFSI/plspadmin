import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;

import 'Model.dart';



class ProgramWindowController {
  final String apiUrl = "$kUrl/FMSR_AdminGetProgramsByWindow";

  final StreamController<ProgramWindowModel?> _streamController =
      StreamController.broadcast();

  Stream<ProgramWindowModel?> get programStream => _streamController.stream;

  void startFetching(String username) async {
    final data = await fetchPrograms(username);
    _streamController.add(data);
  }

  void stopFetching() {
    _streamController.close();
  }

  Future<ProgramWindowModel?> fetchPrograms(String username) async {
    final Uri url =
        Uri.parse(apiUrl).replace(queryParameters: {'username': username});

    try {
      final response = await http.get(url, headers: kHeader);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ProgramWindowModel.fromJson(responseData['data']);
        } else {
          throw Exception("Error: ${responseData['error']}");
        }
      } else {
        throw Exception(
            "Failed to fetch programs. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching programs: $error");
      return null;
    }
  }
}

class CompletedDocumentRequestsController {
  final String apiUrl =
      "$kUrl/FMSR_AdminGetStudentsByProgramFromWindow";
  final StreamController<List<StudentModel>> _streamController =
      StreamController<List<StudentModel>>.broadcast();

  Stream<List<StudentModel>> get completedRequestsStream =>
      _streamController.stream;

  Timer? _timer;

  /// Starts fetching completed requests periodically by username.
  void startFetching(String username) {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _fetchCompletedRequests(username);
    });
  }

  /// Fetch completed requests from the API by username.
  Future<void> _fetchCompletedRequests(String username) async {
    final uri =
        Uri.parse(apiUrl).replace(queryParameters: {'username': username});

    try {
      final response = await http.get(uri, headers: kHeader);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final requests = (responseData['data'] as List)
              .map((json) => StudentModel.fromJson(json))
              .toList();
          _streamController.add(requests);
        } else {
          throw Exception(responseData['error'] ?? "Unknown error occurred");
        }
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError(e);
    }
  }

  /// Stops the periodic fetching and cleans up resources.
  void stopFetching() {
    _timer?.cancel();
  }

  /// Disposes the controller and associated resources.
  void dispose() {
    stopFetching();
    _streamController.close();
  }
}


class DocumentController {
  final StreamController<Document?> _documentStreamController =
      StreamController.broadcast();
  Stream<Document?> get documentStream => _documentStreamController.stream;

  Future<void> fetchDocument(String documentName) async {
    final url = Uri.parse(
        '$kUrl/FMSR_GetDocumentDetailsByName?document_name=$documentName');

    try {
      final response = await http.get(url, headers: kHeader);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final document = Document.fromJson(data);
          print(document);
          _documentStreamController.add(document);
        } else {
          _documentStreamController.add(null);
          print('No document details found.');
        }
      } else {
        _documentStreamController.add(null);
        print('Failed to load document details: ${response.body}');
      }
    } catch (e) {
      _documentStreamController.add(null);
      print('Error fetching document details: $e');
    }
  }

  void dispose() {
    _documentStreamController.close();
  }
}

class DocumentRequestController {
  final String apiUrl = "$kUrl/FMSR_UpdateToObtainedStatus";

  Future<bool> updateDocumentRequest(DocumentRequest request) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode({
          "username": request.username,
          "documentName": request.documentName,
          "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(request.date),
          "requirements1": request.requirements1,
          "requirements2": request.requirements2,
          "email": request.email,
          "window": request.window,
          "obtainedDate": request.obtainedDate != null
              ? DateFormat("yyyy-MM-dd HH:mm:ss").format(request.obtainedDate!)
              : null, // Send obtainedDate if available
          "adminAssigned": request.adminAssigned, // Include adminAssigned
        }),
      );

      if (response.statusCode == 200) {
        print("Document request updated successfully.");
        return true;
      } else {
        print("Failed to update document request: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating document request: $e");
      return false;
    }
  }
}

class RejectDocumentController {
  final String apiUrl = "$kUrl/FMSR_RejectDocumentRequest";

  Future<bool> rejectDocument(RejectDocumentRequest request) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}

class DocumentStatisticsController {
  final String apiUrl = "$kUrl/FMSR_DocumentRequestStatusStatistics";
  final _streamController =
      StreamController<DocumentStatisticsResponse>.broadcast();

  Stream<DocumentStatisticsResponse> get statisticsStream =>
      _streamController.stream;

  Future<void> fetchStatistics() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final statistics = DocumentStatisticsResponse.fromJson(data);
        _streamController.sink.add(statistics);
      } else {
        print("Failed to load statistics. Status Code: ${response.statusCode}");
        _streamController.addError("Failed to load statistics.");
      }
    } catch (e) {
      print("Error fetching statistics: $e");
      _streamController.addError("Error fetching statistics: $e");
    }
  }

  // Periodic fetching of data
  void startFetching({Duration interval = const Duration(seconds: 3)}) {
    fetchStatistics(); // Initial fetch
    Timer.periodic(interval, (_) => fetchStatistics());
  }

  // Dispose the stream controller
  void dispose() {
    _streamController.close();
  }
}

class ObtainedRequestController {
  final String apiUrl = '$kUrl/FMSR_GetObtainedRequestsByStudent';

  final StreamController<List<ObtainedRequest>?> _obtainedRequestController =
      StreamController<List<ObtainedRequest>?>.broadcast();

  Stream<List<ObtainedRequest>?> get obtainedRequestsStream =>
      _obtainedRequestController.stream;

  Future<void> fetchObtainedRequests(String username) async {
    // Clear the current stream data to indicate loading
    _obtainedRequestController.sink.add(null);

    try {
      final response = await http.get(Uri.parse('$apiUrl?username=$username'),
          headers: kHeader);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          final List<dynamic> data = decoded['data'];
          final requests = data
              .map((json) => ObtainedRequest.fromJson(json))
              .toList();
          _obtainedRequestController.sink.add(requests); // Add new data
          print('Stream updated with ${requests.length} requests');
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        _obtainedRequestController.sink.add([]); // No data
      }
    } catch (error) {
      _obtainedRequestController.sink.addError('Failed to fetch requests: $error');
      print('Error fetching data: $error');
    }
  }

  void dispose() {
    _obtainedRequestController.close();
  }
}