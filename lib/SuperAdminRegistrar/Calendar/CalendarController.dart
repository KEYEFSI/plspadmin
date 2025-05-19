import 'dart:convert';
import 'package:plsp/SuperAdmin/Calendar/CalendarModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HolidayDateController extends ChangeNotifier {
  List<HolidayDate> _holidayDates = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HolidayDate> get holidayDates => _holidayDates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> refreshCalendar() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await fetchHolidayDates();

    _isLoading = false;
    notifyListeners();
  }


  Future<void> fetchHolidayDates() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$kUrl/FMSR_AdminShowHolidayDates'),
      headers:kHeader); // Replace with actual URL and headers

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _holidayDates = data.map((item) => HolidayDate.fromJson(item)).toList();
        print(response.body);
      } else {
        _errorMessage = 'Failed to load holiday dates';
      }
    } catch (error) {
      _errorMessage = 'Failed to load holiday dates: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
  }
  
}


class HolidayInsert {
  final String apiUrl;

  HolidayInsert(this.apiUrl);

  Future<void> insertHolidayDate(String eventName, DateTime date) async {
    if (eventName.isEmpty) {
      throw ArgumentError('Event name and date are required');
    }

    // Format date to match your database format
    final formattedDate = _formatDate(date);

    final response = await http.post(
      Uri.parse('$apiUrl/FMSR_AdminInsertHolidayDates'),
      headers: kHeader,
      body: json.encode({
        'event_name': eventName,
        'date': formattedDate,
      }),
    );

    if (response.statusCode == 201) {
      print('Holiday date inserted successfully');
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Error inserting holiday date: ${errorResponse['error']}');
    }
  }

  String _formatDate(DateTime date) {
    // Format date as 'YYYY-MM-DD'
    return '${date.toLocal().year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class HolidayDateDeleteController with ChangeNotifier {
  final String apiUrl = "$kUrl/FMSR_AdminDeleteHolidayDates";

  Future<void> deleteHolidayDate(String eventName, DateTime date) async {
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers:kHeader,
      body: json.encode({
        "event_name": eventName,
        "date": formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      notifyListeners();
      // Handle success, perhaps refresh the list of holiday dates or show a success message
    } else {
      // Handle error, perhaps show an error message
      throw Exception('Failed to delete holiday date: ${json.decode(response.body)['error']}');
    }
  }
}
