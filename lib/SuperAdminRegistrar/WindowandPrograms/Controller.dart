import 'dart:async';
import 'dart:convert';


import 'package:plsp/SuperAdminRegistrar/WindowandPrograms/Model.dart';
import 'package:plsp/common/common.dart';

import 'package:http/http.dart' as http;



class WindowsController {
  final StreamController<List<Window>> _controller = StreamController<List<Window>>.broadcast();
  final String _apiUrl = "$kUrl/FMSR_GetWindowsData";
  final String _deleteApiUrl = "$kUrl/FMSR_DeleteWindow"; // API for deleting windows

  Stream<List<Window>> get windowsStream => _controller.stream;

  Timer? _refreshTimer; // Timer for auto-refresh

  Future<void> fetchWindowsData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final windows = (data['data'] as List)
              .map((window) => Window.fromJson(window))
              .toList();
          _controller.add(windows);
        } else {
          throw Exception(data['error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to fetch windows data');
      }
    } catch (e) {
      print("Error fetching windows data: $e");
      _controller.addError(e);
    }
  }

  Future<void> deleteWindow(String windowName) async {
    try {
      final response = await http.delete(
        Uri.parse(_deleteApiUrl),
        headers: kHeader,
        body: jsonEncode({'windowId': windowName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          fetchWindowsData(); // Refresh data after successful deletion
        } else {
          throw Exception(data['error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to delete window');
      }
    } catch (e) {
      print("Error deleting window: $e");
      rethrow; // Allow error handling in the caller
    }
  }

  void startAutoRefresh({Duration interval = const Duration(seconds: 1)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) {
      fetchWindowsData();
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void dispose() {
    _refreshTimer?.cancel();
    _controller.close();
  }
}


class WindowController {
  final String apiUrl = "$kUrl/FMSR_CreateWindow";

  Future<WindowCreate?> createWindow() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers:kHeader,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return WindowCreate.fromJson(data['data']);
      } else {
        print("Failed to create window: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error creating window: $e");
      return null;
    }
  }
}

class UnselectedProgramController {
  final String apiUrl = "$kUrl/FMSR_GetUnselectedPrograms"; // Replace with your API base URL

  // Method to periodically fetch unselected programs every 3 seconds
  Stream<List<UnselectedProgram>> getUnselectedProgramsStream() async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body)['unselectedPrograms'];

          // Map the response to a list of UnselectedProgram objects
          List<UnselectedProgram> programs = data
              .map((jsonItem) => UnselectedProgram.fromJson(jsonItem))
              .toList();

          yield programs; // Emit the list of programs
        } else {
          throw Exception('Failed to load unselected programs');
        }
      } catch (error) {
        print("Error fetching unselected programs: $error");
        yield []; // If there's an error, emit an empty list
      }

      // Wait for 3 seconds before fetching again
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

class ProgramController {
  final String apiUrl = "$kUrl/FMSR_AddProgramToWindow";

  Future<bool> addProgram(AddProgramRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: 
         kHeader,
        
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Successfully added program
      } else {
        print('Failed to add program: ${response.body}');
        return false; // Failed
      }
    } catch (e) {
      print('Error adding program: $e');
      return false;
    }
  }
}
class DeleteProgramController {
  final String apiUrl = "$kUrl/FMSR_DeleteProgramFromWindow";

  // Function to delete the program from the window
  Future<DeleteProgramResponse> deleteProgram(String windowName, String program) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers:kHeader,
      body: jsonEncode({
        'window_name': windowName,
        'program': program,
      }),
    );

    if (response.statusCode == 200) {
      return DeleteProgramResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete program');
    }
  }
}

class CourseController {
  final String apiUrl = "$kUrl/FMSR_GetCoursesData";

  final StreamController<List<CourseModel>> _streamController = StreamController.broadcast();

  Stream<List<CourseModel>> get coursesStream => _streamController.stream;

  Timer? _refreshTimer;

  CourseController() {
    _startAutoRefresh();
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          final List<dynamic> data = jsonData['data'];
          final courses = data.map((course) => CourseModel.fromJson(course)).toList();
          _streamController.add(courses);
        } else {
          _streamController.addError("Failed to fetch courses");
        }
      } else {
        _streamController.addError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("An error occurred: $e");
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchCourses();
    });
  }

  void dispose() {
    _refreshTimer?.cancel();
    _streamController.close();
  }

   Future<bool> deleteCourse(String acronym) async {
    final response = await http.delete(
      Uri.parse('$kUrl/FMSR_DeleteCourse'),
      headers: kHeader,
      body: jsonEncode({'acronym': acronym}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception("Failed to delete course");
    }
  }

    Future<bool> addCourse(CourseModel course) async {
  try {
    final response = await http.post(
      Uri.parse('$kUrl/FMSR_AddCourse'),
      headers: kHeader,
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      print("Failed to add course: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error adding course: $e");
    return false;
  }
}

}