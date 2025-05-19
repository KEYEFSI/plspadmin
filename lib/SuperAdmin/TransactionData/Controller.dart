import 'dart:async';
import 'dart:convert';

import 'Model.dart';

import 'package:plsp/common/common.dart';

import 'package:http/http.dart' as http;

class TransactionController {
  final StreamController<List<TransactionModel>> _streamController =
      StreamController<List<TransactionModel>>.broadcast();
  Timer? _timer;

  String _sortBy = "date"; // Default sorting field
  bool _isAscending = false; // Default sorting order (false = descending)
  bool isDateAscending = true;
  bool isInvoiceAscending = true;

  TransactionController() {
    _startAutoRefresh();
  }

  Stream<List<TransactionModel>> get transactionStream =>
      _streamController.stream;

  void _startAutoRefresh() {
    _fetchData(); // Initial fetch
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchData();
    });
  }

  void toggleSortOrder(String sortBy) {
    if (sortBy == "date") {
      isDateAscending = !isDateAscending;
    } else if (sortBy == "invoice") {
      isInvoiceAscending = !isInvoiceAscending;
    }
    _sortBy = sortBy;
    _fetchData();
  }

  void setSortOptions(String sortBy, bool isAscending) {
    _sortBy = sortBy;
    _isAscending = isAscending;
    _fetchData();
  }

  // New method to fetch data for a specific month and year
  Future<void> fetchDataForMonthYear(int year, int month) async {
    try {
      List<TransactionModel> allData = await _fetchTransactionDataFromApi();
      List<TransactionModel> filteredData = allData.where((transaction) {
        return transaction.date != null &&
            transaction.date!.year == year &&
            transaction.date!.month == month;
      }).toList();

      // Apply current sorting to the filtered data
      filteredData.sort((a, b) {
        int comparison = 0;

        if (_sortBy == "date") {
          final dateA = a.date;
          final dateB = b.date;

          if (dateA == null && dateB != null) {
            comparison = _isAscending ? -1 : 1;
          } else if (dateA != null && dateB == null) {
            comparison = _isAscending ? 1 : -1;
          } else if (dateA != null && dateB != null) {
            if (dateA.year != dateB.year) {
              comparison = dateA.year.compareTo(dateB.year);
            } else {
              comparison = dateA.month.compareTo(dateB.month);
            }
            return isDateAscending ? comparison : -comparison;
          } else {
            comparison = 0;
          }
          return comparison;
        }

        if (_sortBy == "invoice") {
          comparison = (a.invoice ?? 0).compareTo(b.invoice ?? 0);
          return isInvoiceAscending ? comparison : -comparison;
        }

        if (_sortBy == "feename") {
          if (a.feeName == null && b.feeName != null) {
            return _isAscending ? -1 : 1;
          } else if (a.feeName != null && b.feeName == null) {
            return _isAscending ? 1 : -1;
          } else if (a.feeName != null && b.feeName != null) {
            return _isAscending
                ? a.feeName!.compareTo(b.feeName!)
                : b.feeName!.compareTo(a.feeName!);
          } else {
            return 0;
          }
        }

        return 0;
      });

      _streamController.add(filteredData);
    } catch (e) {
      _streamController.addError("Failed to load data for the specified month: $e");
    }
  }

  Future<void> _fetchData() async {
    try {
      List<TransactionModel> data = await _fetchTransactionDataFromApi();
      data.sort((a, b) {
        int comparison = 0;

        if (_sortBy == "date") {
          final dateA = a.date;
          final dateB = b.date;

          if (dateA == null && dateB != null) {
            comparison = _isAscending ? -1 : 1;
          } else if (dateA != null && dateB == null) {
            comparison = _isAscending ? 1 : -1;
          } else if (dateA != null && dateB != null) {
            if (dateA.year != dateB.year) {
              comparison = dateA.year.compareTo(dateB.year);
            } else {
              comparison = dateA.month.compareTo(dateB.month);
            }
            return isDateAscending ? comparison : -comparison;
          } else {
            comparison = 0;
          }
          return comparison;
        }

        if (_sortBy == "invoice") {
          comparison = (a.invoice ?? 0).compareTo(b.invoice ?? 0);
          return isInvoiceAscending ? comparison : -comparison;
        }

        if (_sortBy == "feename") {
          if (a.feeName == null && b.feeName != null) {
            return _isAscending ? -1 : 1;
          } else if (a.feeName != null && b.feeName == null) {
            return _isAscending ? 1 : -1;
          } else if (a.feeName != null && b.feeName != null) {
            return _isAscending
                ? a.feeName!.compareTo(b.feeName!)
                : b.feeName!.compareTo(a.feeName!);
          } else {
            return 0;
          }
        }

        return 0;
      });

      _streamController.add(data);
    } catch (e) {
      _streamController.addError("Failed to load data: $e");
    }
  }

  void refreshData() {
    _fetchData();
  }

  Future<List<TransactionModel>> _fetchTransactionDataFromApi() async {
    try {
      final response = await http.get(Uri.parse("$kUrl/FMSR_AllTransactions"),
          headers: kHeader);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        return jsonData.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      print("Error fetching data from API: $e");
      throw Exception("Failed to fetch data");
    }
  }

  Future<List<TransactionModel>> getTransactionsByInvoices(
      List<int> invoices) async {
    try {
      final response = await http.post(
        Uri.parse("$kUrl/FMSR_TransactionsByInvoices"),
        headers: kHeader,
        body: jsonEncode({'invoices': invoices}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        return jsonData.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception(
            "Failed to fetch transactions for invoices: ${response.body}");
      }
    } catch (e) {
      print("Error in getTransactionsByInvoices: $e");
      throw Exception("Error fetching transactions: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}



class DeleteTransactionsController {
  final String apiUrl = "$kUrl/FMSR_DeleteTransactions";

  Future<bool> deleteSelectedTransactions(List<int> invoices) async {
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode({'invoices': invoices}), // Passing List<int> directly
      );

      if (response.statusCode == 200) {
        print("Transactions deleted successfully.");
        return true;
      } else {
        print("Error deleting transactions: ${response.body}");
        return false;
      }
    } catch (e) { 
      print("Exception deleting transactions: $e");
      return false;
    }
  }
}

class LoginController {
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    final String apiUrl =
        '$kUrl/FMSR_AdminLogin'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: jsonEncode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response
              .body), // This will return user details if login is successful
        };
      } else {
        return {
          'success': false,
          'error': jsonDecode(
              response.body)['error'], // Capture error message from response
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

class UpdateTransaction {
  static const String apiUrl = '$kUrl/FMSR_AdminUpdateTransaction';

  Future<Map<String, dynamic>> updateTransaction(
      Transaction transaction) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: kHeader,
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Transaction updated successfully'};
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['error']
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
