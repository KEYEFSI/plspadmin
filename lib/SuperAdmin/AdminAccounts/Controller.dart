import 'dart:async';
import 'dart:convert';


import 'Model.dart';
import 'package:plsp/common/common.dart';

import 'package:http/http.dart' as http;

class AdminController {
  final String apiUrl = "$kUrl/FMSR_FinanceAdmins";

  final StreamController<List<AdminModel>> _adminStreamController = StreamController.broadcast();
  Stream<List<AdminModel>> get adminStream => _adminStreamController.stream;

  Timer? _timer;

  AdminController() {
    _startAutoRefresh();
  }

  Future<void> fetchAdmins() async {
    try {
      final response = await http.get(Uri.parse(apiUrl),
      headers: kHeader);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final admins = (data['data'] as List)
              .map((json) => AdminModel.fromJson(json))
              .toList();
          _adminStreamController.add(admins);
        } else {
          _adminStreamController.addError("Failed to fetch data.");
        }
      } else {
        _adminStreamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _adminStreamController.addError("Error: $e");
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) => fetchAdmins());
  }

  void dispose() {
    _timer?.cancel();
    _adminStreamController.close();
  }
}

class LoginController {
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    final String apiUrl = '$kUrl/FMSR_AdminLogin'; // Update this with your API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers:kHeader,
        body: jsonEncode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body), // This will return user details if login is successful
        };
      } else {
        return {
          'success': false,
          'error': jsonDecode(response.body)['error'], // Capture error message from response
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: $e',
      };
    }
  }
}

class WindowController {
  final StreamController<List<WindowData>> _streamController =
      StreamController<List<WindowData>>();
  late Timer _timer; // Timer for auto-refresh

  Stream<List<WindowData>> get stream => _streamController.stream;

  // Fetch data from the API
  Future<void> fetchWindowData() async {
    try {
      final response = await http.get(Uri.parse('$kUrl/FMSR_GetWindowsData'),
      headers: kHeader);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        final List<WindowData> windows = data.map((item) => WindowData.fromJson(item)).toList();
        _streamController.add(windows); // Add the fetched data to the stream
      } else {
        _streamController.addError('Failed to load windows data');
      }
    } catch (e) {
      _streamController.addError('Error: $e');
    }
  }

  // Start the timer to refresh data every second
  void startAutoRefresh() {
    fetchWindowData(); // Fetch data immediately when starting
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchWindowData();
    });
  }

  // Stop the timer when no longer needed
  void stopAutoRefresh() {
    _timer.cancel();
  }

  // Dispose of resources
  void dispose() {
    stopAutoRefresh();
    _streamController.close();
  }
}


class CreateFinanceAdminController {
  final String apiUrl = "$kUrl/FMSR_FinanceAdmins_Save"; // Replace with your actual API URL

  // Method to create a new Finance Admin
  Future<Map<String, dynamic>> createFinanceAdmin(CreateFinanceAdminModel admin) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(admin.toJson()),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Finance Admin account created successfully'};
      } else {
        // Extract error message from the response if available
        final errorMessage = jsonDecode(response.body)['error'] ?? 'Failed to create Finance Admin account';
        return {'success': false, 'message': errorMessage};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error: $error'};
    }
  }
}

class DeleteAdminController {
  final String apiUrl = '$kUrl/AdminsRemove'; // Replace with your API URL
  bool isLoading = false;
  String? errorMessage;

  Future<bool> removeAdmin(String username) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$username'),
        headers: kHeader,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        errorMessage = responseData['error'] ?? 'An error occurred';
        return false;
      }
    } catch (error) {
      errorMessage = 'Failed to connect to the server';
      return false;
    } finally {
      isLoading = false;
    }
  }
}