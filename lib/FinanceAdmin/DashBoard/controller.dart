import 'dart:async';
import 'dart:convert';

import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Model.dart';


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

class RequestCountsTodayController {
  final String wsUrl = '$kWebSocketUrl/FMSR_GetAllCounts';
  
  final StreamController<RequestCountsToday> _controller = StreamController<RequestCountsToday>.broadcast();
  WebSocketChannel? _channel;
  bool _isWebSocketConnected = false;

  Stream<RequestCountsToday> get requestCountsStream => _controller.stream;

  RequestCountsTodayController() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    if (_isWebSocketConnected) return;

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      _isWebSocketConnected = true;
      print('WebSocket connected to $wsUrl');

      _channel!.stream.listen((message) {
        print('Received WebSocket message: $message');

        final data = json.decode(message);
        final requestCountsToday = RequestCountsToday.fromJson(data);

        _controller.add(requestCountsToday);
      }, onError: (error) {
        print('WebSocket error: $error');
        _reconnectWebSocket();
      }, onDone: () {
        print('WebSocket connection closed.');
        _reconnectWebSocket();
      });
    } catch (e) {
      print('WebSocket connection failed: $e');
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    _isWebSocketConnected = false;
    Future.delayed(Duration(seconds: 3), _initializeWebSocket);
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }
}

class RequestStatsController {
  final String wsUrl = '$kWebSocketUrl/FMSR_GetDailyCounts';

  final StreamController<RequestStats> _controller = StreamController<RequestStats>.broadcast();
  WebSocketChannel? _channel;
  bool _isWebSocketConnected = false;

  Stream<RequestStats> get requestStatsStream => _controller.stream;

  RequestStatsController() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    if (_isWebSocketConnected) return;

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      print('Connecting to WebSocket: $wsUrl');

      _channel!.stream.listen(
        (message) {
          print('Received WebSocket message: $message');

          final data = json.decode(message);
          final requestStats = RequestStats.fromJson(data);

          _controller.add(requestStats);
          _isWebSocketConnected = true; 
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isWebSocketConnected = false;
          _reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket connection closed.');
          _isWebSocketConnected = false;
          _reconnectWebSocket();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
      _isWebSocketConnected = false;
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    if (_isWebSocketConnected) return; // Prevent multiple reconnect attempts
    print('Reconnecting WebSocket in 3 seconds...');
    Future.delayed(Duration(seconds: 3), _initializeWebSocket);
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }
}
class HolidayDatesController {
  final String wsUrl = '$kWebSocketUrl/FMSR_GetPerDateData'; // WebSocket URL
  final StreamController<CombinedData> _controller = StreamController<CombinedData>.broadcast();
  IOWebSocketChannel? _channel;
  bool _isWebSocketConnected = false;

  Stream<CombinedData> get combinedDataStream => _controller.stream;

  HolidayDatesController() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    if (_isWebSocketConnected) return;

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      print('Connecting to WebSocket: $wsUrl');

      _channel!.stream.listen(
        (message) {
          print('Received WebSocket message: $message');

          final data = json.decode(message);
          final combinedData = CombinedData.fromJson(data);

          _controller.add(combinedData);
          _isWebSocketConnected = true;
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isWebSocketConnected = false;
          _reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket connection closed.');
          _isWebSocketConnected = false;
          _reconnectWebSocket();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
      _isWebSocketConnected = false;
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    if (_isWebSocketConnected) return; // Prevent multiple reconnect attempts
    print('Reconnecting WebSocket in 3 seconds...');
    Future.delayed(Duration(seconds: 1), _initializeWebSocket);
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }
}
