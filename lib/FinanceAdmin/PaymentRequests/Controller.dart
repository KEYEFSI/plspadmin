import 'dart:async';
import 'dart:convert';


import 'package:plsp/common/common.dart';

import 'package:http/http.dart' as http;

import 'Model.dart';




class ORNumberController {
  final String apiUrl = "$kUrl/FMSR_CurrentORNumber"; // Replace `$kUrl` with your base URL
  final StreamController<String?> _orNumberStreamController =
      StreamController<String?>.broadcast();
  Timer? _refreshTimer; // Timer for periodic updates

  Stream<String?> get orNumberStream => _orNumberStreamController.stream;

  /// Fetches the current OR number and adds it to the stream.
  Future<void> fetchCurrentORNumber() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: kHeader, // Replace `kHeader` with your actual headers
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Convert the OR number to a String if it's an integer
        final currentORNumber = data['current_or_number'];
        if (currentORNumber != null) {
          _orNumberStreamController.add(currentORNumber.toString());
        } else {
          _orNumberStreamController.add(null);
        }
      } else if (response.statusCode == 404) {
        print('No OR number found.');
        _orNumberStreamController.add(null);
      } else {
        print('Failed to fetch OR number: ${response.body}');
        _orNumberStreamController.addError('Failed to fetch OR number.');
      }
    } catch (e) {
      print('Error fetching OR number: $e');
      _orNumberStreamController.addError('Error fetching OR number: $e');
    }
  }

  /// Starts a timer to refresh the OR number every second.
  void startRefreshing() {
    _refreshTimer?.cancel(); // Cancel any existing timer
    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchCurrentORNumber();
    });
  }

  /// Stops the refresh timer.
  void stopRefreshing() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Disposes the stream controller and timer when not needed.
  void dispose() {
    _orNumberStreamController.close();
    stopRefreshing();
  }
}

class UnpaidRequestsController {
  final StreamController<List<UnpaidRequest>> _streamController =
      StreamController<List<UnpaidRequest>>();
  late Timer _timer;
  final String apiUrl = "$kUrl/FMSR_GetUnpaidPaymentRequests";

  Stream<List<UnpaidRequest>> get stream => _streamController.stream;

  UnpaidRequestsController() {
    _fetchData(); // Initial fetch
    _timer = Timer.periodic(
      Duration(seconds: 3), // Fetch data every 3 seconds
      (_) => _fetchData(),
    );
  }

  void _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: kHeader,
      );

      if (response.statusCode == 200) {
        print(response.body);
        
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final unpaidRequests = data
            .map((item) => UnpaidRequest.fromJson(item))
            .toList()
            .cast<UnpaidRequest>();
        _streamController.add(unpaidRequests);
      } else {
        _streamController.addError(
          'Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (error) {
      _streamController.addError('Error fetching data: $error');
    }
  }

  void dispose() {
    _timer.cancel();
    _streamController.close();
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

class TransactionController {
  final String apiUrl = "$kUrl/FMSR_Transactions";

  Future<bool> submitTransaction(TransactionModel transaction) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print('Error: ${response.body}');
        return false; // Failure
      }
    } catch (e) {
      print('Exception: $e');
      return false; // Error
    }
  }
}


class UpdateController {
  final String apiUrl = "$kUrl/FMSR_UpdatePaymentRequest";

  Future<Map<String, dynamic>> updatePaymentRequest({
    required String username,
    required String feeName,
    required double price,
    required double oldBalance,
    required double newBalance,
    required int invoiceNo,
    required String adminAssigned,
    required DateTime date,
    required String email, // Add email parameter here
  }) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode({
          'username': username,
          'feeName': feeName,
          'price': price,
          'oldBalance': oldBalance,
          'newBalance': newBalance,
          'invoiceNo': invoiceNo,
          'adminAssigned': adminAssigned,
          'date': date.toIso8601String(),
          'email': email, // Include email in the body
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Failed to update payment request',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}