import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:plsp/RegistrarsAdmin/PendingDocuments/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ProgramWindowController {
  final String apiUrl = "$kUrl/FMSR_AdminGetProgramsByWindow";

  final StreamController<ProgramWindowModel?> _streamController = StreamController.broadcast();

  Stream<ProgramWindowModel?> get programStream => _streamController.stream;

  void startFetching(String username) async {
    final data = await fetchPrograms(username);
    _streamController.add(data);
  }

  void stopFetching() {
    _streamController.close();
  }

  Future<ProgramWindowModel?> fetchPrograms(String username) async {
    final Uri url = Uri.parse(apiUrl).replace(queryParameters: {'username': username});

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
        throw Exception("Failed to fetch programs. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching programs: $error");
      return null;
    }
  }
}


class PendingDocumentRequestsController {
  final String apiUrl = "$kUrl/FMSR_AdminGetPendingRequestsByProgramFromWindow";
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


  Future<void> _fetchPendingRequests(String username) async {
    final uri = Uri.parse(apiUrl).replace(queryParameters: {'username': username});
  
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
          _streamController.addError(Exception(responseData['error'] ?? "Unknown error occurred"));
        }
      } else {
        _streamController.addError(Exception("Failed to fetch data: ${response.statusCode}"));
      }
    } catch (e) {
      _streamController.addError(Exception("Error fetching pending requests: $e"));
    }
  }


  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class DocumentController {
  final StreamController<Document?> _documentStreamController = StreamController.broadcast();
  Stream<Document?> get documentStream => _documentStreamController.stream;

  Future<void> fetchDocument(String documentName) async {
    final url = Uri.parse('$kUrl/FMSR_GetDocumentDetailsByName?document_name=$documentName');
 
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
  final String apiUrl = "$kUrl/FMSR_UpdateDocumentRequest";

  Future<bool> updateDocumentRequest(DocumentRequest request) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(request.toJson()),
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
  final String apiUrl = "$kUrl/FMSR_DocumentRequestsStatistics";
  final _streamController = StreamController<DocumentStatisticsResponse>.broadcast();

  Stream<DocumentStatisticsResponse> get statisticsStream => _streamController.stream;

  Future<void> fetchStatistics() async {
    try {
      final response = await http.get(Uri.parse(apiUrl),
      headers: kHeader);

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


class StampController {
  Future<List<Stamp>> fetchStamps() async {
    final url = Uri.parse("$kUrl/FMSR_GetStamp");

    try {
      final response = await http.get(url,
      headers: kHeader);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((item) => Stamp.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load stamps");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}