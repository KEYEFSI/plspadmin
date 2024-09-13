import 'dart:convert';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'RequestCounterModel.dart';

class RequestCountController with ChangeNotifier {
  List<RequestCount> _requestCounts = [];
  bool _isLoading = false;

  List<RequestCount> get requestCounts => _requestCounts;
  bool get isLoading => _isLoading;

  Future<void> fetchRequestCounts() async {
    _isLoading = true;
    notifyListeners();

    final url = '$kUrl/FMSR_GetCountRequests';
    try {
      final response = await http.get(Uri.parse(url),
      headers: kHeader);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _requestCounts = data.map((json) => RequestCount.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load request counts');
      }
    } catch (error) {
      print('Error fetching request counts: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

