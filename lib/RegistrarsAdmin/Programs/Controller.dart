import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:plsp/RegistrarsAdmin/Programs/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;



class CourseController {
  // Fetch courses from the API
  Future<List<Courses>> fetchCourses() async {
    try {
      final response =
          await http.get(Uri.parse('$kUrl/FMSR_GetCourses'), headers: kHeader);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(response.body);
        if (data is List && data.isNotEmpty) {
          return List<Courses>.from(
            data.map((item) => Courses.fromJson(item)),
          );
        } else {
          return [];
        }
      } else {
        // Handle non-200 status codes if needed
        print('Failed to load courses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle error, for example log it or show a message
      print('Error fetching courses: $e');
      return [];
    }
  }
}



class InsertController {
  final String apiUrl = '$kUrl/FMSR_InsertCourse'; // Update with your actual API URL

  Future<bool> insertCourse(Courses course) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: kHeader,
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 201) {
      // Successfully inserted course
      return true;
    } else {
      // Failed to insert course
      return false;
    }
  }
}


  class CourseService {
    final String apiUrl = '$kUrl/FMSR_GetCoursesWithStudentCounts';
    final StreamController<List<CourseWithStudentCount>> _courseController = StreamController<List<CourseWithStudentCount>>.broadcast();
    Timer? _timer;
    bool _isFetching = false;

    CourseService() {
      _startPeriodicFetch();
    }

    Stream<List<CourseWithStudentCount>> get courseStream => _courseController.stream;

    Future<void> _fetchCourseData() async {
      if (_isFetching) {
        throw Exception('Fetch already in progress'); // Prevent concurrent fetches
      }
      _isFetching = true;

      try {
        final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          List<CourseWithStudentCount> courses = data
              .map((courseJson) => CourseWithStudentCount.fromJson(courseJson))
              .toList();
          _courseController.sink.add(courses);
        } else {
          throw Exception('Failed to load course data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching course data: $e');
      } finally {
        _isFetching = false;
      }
    }

    void _startPeriodicFetch() {
      _fetchCourseData(); // Fetch initial data
      _timer = Timer.periodic(Duration(seconds: 30), (_) => _fetchCourseData());
    }

    void refreshCourseData() async {
      // Manually trigger fetching data and adding it to the stream
      try {
        await _fetchCourseData();
      } catch (e) {
        print('Error refreshing course data: $e');
      }
    }

    void dispose() {
      _courseController.close();
      _timer?.cancel();
    }
  }
class CounterController {
  final String apiUrl;
  final StreamController<CounterData> _streamController = StreamController<CounterData>.broadcast();
  bool _isFetching = false;

  CounterController({required this.apiUrl});

  Stream<CounterData> get stream => _streamController.stream;

  Future<CounterData> fetchCounterData() async {
    if (_isFetching) {
      throw Exception('Fetch already in progress'); // Prevent concurrent fetches
    }
    _isFetching = true;

    try {
      // Fetch data from the API
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final counterData = CounterData.fromJson(json);

        // Add the fetched data to the stream
        _streamController.add(counterData);

        return counterData;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to be handled by the caller
    } finally {
      _isFetching = false;
    }
  }

  void refreshCounterData() async {
    // Manually trigger fetching data and adding it to the stream
    try {
      await fetchCounterData();
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  void dispose() {
    // Close the stream controller
    _streamController.close();
  }
}