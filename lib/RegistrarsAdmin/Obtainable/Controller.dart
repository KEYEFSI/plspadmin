import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:plsp/RegistrarsAdmin/Obtainable/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;

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

class PendingDocumentRequestsController {
  final String apiUrl = "$kUrl/FMSR_AdminGetCompletedRequestsByProgramFromWindow";
  final StreamController<List<PendingDocumentRequest>> _streamController =
      StreamController<List<PendingDocumentRequest>>();

  Stream<List<PendingDocumentRequest>> get pendingRequestsStream =>
      _streamController.stream;

  Timer? _timer;

  /// Start fetching pending requests by username
  void startFetching(String username) {
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      await _fetchPendingRequests(username);
    });
  }

  /// Fetch pending requests from the API
  Future<void> _fetchPendingRequests(String username) async {
    final uri =
        Uri.parse(apiUrl).replace(queryParameters: {'username': username});

    try {
      final response = await http.get(uri, headers: kHeader);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success']) {
          final requests = (responseData['data'] as List)
              .map((json) => PendingDocumentRequest.fromJson(json))
              .toList();
          _streamController.add(requests);
        } else {
          _streamController.addError(
              Exception(responseData['error'] ?? "Unknown error occurred"));
        }
      } else {
        _streamController.addError(
            Exception("Failed to fetch data: ${response.statusCode}"));
      }
    } catch (e) {
      _streamController
          .addError(Exception("Error fetching pending requests: $e"));
    }
  }

  /// Dispose the stream and cancel the timer
  void dispose() {
    _timer?.cancel();
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
