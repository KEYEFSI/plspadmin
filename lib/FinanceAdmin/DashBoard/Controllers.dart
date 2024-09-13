


import 'dart:async';
import 'dart:convert';

import 'package:plsp/FinanceAdmin/DashBoard/Model.dart';
import 'package:http/http.dart' as http;

import '../../common/common.dart';








class CurrentORNumberController {
  final String apiUrl = '$kUrl/FMSR_CurrentORNumber';

  Future<CurrentORNumber?> fetchCurrentORNumber() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final currentORNumber = CurrentORNumber.fromJson(json);
        return currentORNumber;
      } else {
        print("Failed to fetch OR number: ${response.body}");
        return null;
      }
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }
}

class ORNumberController {
  final String apiUrl = '$kUrl/FMSR_UpdateORNumber'; // Replace with your actual API URL

  Future<bool> updateORNumber(int orNumber) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode({
          'or_number': orNumber,
        }),
      );

      if (response.statusCode == 200) {
        // OR number updated successfully
        return true;
      } else {
        // Handle error response
        print('Failed to update OR number: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle any network or request errors
      print('Error updating OR number: $e');
      return false;
    }
  }
}

class RequestStatisticsController {
  final String apiUrl = '$kUrl/FMSR_GetAllStudentsCount';
  Timer? _timer;
  final StreamController<RequestStatistics> _controller = StreamController<RequestStatistics>.broadcast();

  Stream<RequestStatistics> get statisticsStream => _controller.stream;

  RequestStatisticsController() {
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
      final response = await http.get(Uri.parse(apiUrl),
      headers: kHeader);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final statistics = RequestStatistics.fromJson(data);
        _controller.add(statistics); // Add the data to the stream
      } else {
        throw Exception('Failed to load request statistics');
      }
    } catch (e) {
      // Handle errors here, if needed
      print('Error fetching statistics: $e');
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}





class HolidayDatesController {
  final String apiUrl = '$kUrl/FMSR_GetCombinedData';
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
        print(response.body);
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

class RequestCountsTodayController {
  final String apiUrl = '$kUrl/FMSR_GetRequestCountsForToday';
  Timer? _timer;
  final StreamController<RequestCountsToday> _controller = StreamController<RequestCountsToday>.broadcast();

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
        final requestCountsToday = RequestCountsToday.fromJson(data);
        _controller.add(requestCountsToday); // Add the data to the stream
      } else {
        throw Exception('Failed to load request counts for today');
      }
    } catch (e) {
      print('Error fetching request counts for today: $e');
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}

