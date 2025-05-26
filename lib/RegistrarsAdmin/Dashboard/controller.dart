import 'dart:async';
import 'dart:convert';
import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'Model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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
  final String wsUrl = '$kWebSocketUrl/FMSR_GetPerDateData'; 
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