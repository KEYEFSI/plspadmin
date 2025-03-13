import 'dart:async';
import 'dart:convert';

import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;

import 'Model.dart';


class RequestCountsTodayController {
  final String apiUrl = '$kUrl/FMSR_GetAllCounts';  // Updated API URL
  Timer? _timer;
  final StreamController<RequestCountsToday> _controller = StreamController<RequestCountsToday>.broadcast();

  // Public stream to be accessed from the UI
  Stream<RequestCountsToday> get requestCountsStream => _controller.stream;

  RequestCountsTodayController() {
    _startRefreshing();
  }

  void _startRefreshing() {
    // Initial fetch
    _fetchAndUpdate();

    // Set up a timer to refresh every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _fetchAndUpdate();
    });
  }

  Future<void> _fetchAndUpdate() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Parse the response to match your updated structure
        final requestCountsToday = RequestCountsToday.fromJson(data);
        
        // Add the parsed data to the stream
        _controller.add(requestCountsToday);
      } else {
        throw Exception('Failed to load request counts for today');
      }
    } catch (e) {
      print('Error fetching request counts for today: $e');
    }
  }

  // Dispose to cancel timer and close the stream when the controller is no longer needed
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}



class RequestStatsController {
  final String apiUrl = '$kUrl/FMSR_GetDailyCounts';  
  Timer? _timer;
  final StreamController<RequestStats> _controller = StreamController<RequestStats>.broadcast();

  // Public stream to be accessed from the UI
  Stream<RequestStats> get requestStatsStream => _controller.stream;

  RequestStatsController() {
    _startRefreshing();
  }

  void _startRefreshing() {
    // Initial fetch
    _fetchAndUpdate();

    // Set up a timer to refresh every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _fetchAndUpdate();
    });
  }

  Future<void> _fetchAndUpdate() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Parse the response to match your updated structure
        final requestStats = RequestStats.fromJson(data);
        
        // Add the parsed data to the stream
        _controller.add(requestStats);
      } else {
        throw Exception('Failed to load request counts for today');
      }
    } catch (e) {
      print('Error fetching request counts for today: $e');
    }
  }

  // Dispose to cancel timer and close the stream when the controller is no longer needed
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}

class HolidayDatesController {
  final String apiUrl = '$kUrl/FMSR_GetPerDateData'; // Updated endpoint URL
  Timer? _timer;
  final StreamController<CombinedData> _controller = StreamController<CombinedData>.broadcast();

  Stream<CombinedData> get combinedDataStream => _controller.stream;

  HolidayDatesController() {
    _startRefreshing();
  }

  void _startRefreshing() {
    // Initial fetch
    _fetchAndUpdate();

    // Set up a timer to refresh every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _fetchAndUpdate();
    });
  }

  Future<void> _fetchAndUpdate() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final combinedData = CombinedData.fromJson(data);
        _controller.add(combinedData); // Add data to the stream
      } else {
        throw Exception('Failed to load combined data');
      }
    } catch (e) {
      print('Error fetching combined data: $e');
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}