import 'dart:convert';
import 'package:plsp/SuperAdmin/Calendar/CalendarModel.dart';
import 'package:plsp/common/common.dart';
import 'package:http/http.dart' as http;

class InsertHolidayDateController {
  final String baseUrl;
  final http.Client client;

  InsertHolidayDateController({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<void> insertHolidayDate(HolidayDate holidayDate) async {
    final url = Uri.parse('$baseUrl/FMSR_AdminInsertHolidayDates');

    final response = await client.post(
      url,
      headers: kHeader,
      body: jsonEncode(holidayDate.toJson()),
    );

    if (response.statusCode == 201) {
      print('Holiday date inserted successfully');
    } else {
      final errorMessage = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to insert holiday date: $errorMessage');
    }
  }
}
