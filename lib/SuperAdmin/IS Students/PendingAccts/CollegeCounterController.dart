import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/CollegeCounterModel.dart';
import 'package:plsp/common/common.dart';

class ISStudentController {
  final String apiUrl = "$kUrl/FMSR_GetISStudents";
  final StreamController<List<ISStudent>> _streamController =
      StreamController<List<ISStudent>>.broadcast();
  Timer? _timer;

  ISStudentController() {
    _startAutoRefresh();
  }

  Stream<List<ISStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchISStudents();
    });
  }

  Future<void> _fetchISStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl),
      headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<ISStudent> students = (data['data'] as List)
              .map((student) => ISStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load IS Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class DeleteStudentController {
  final String apiUrl = "$kUrl/FMSR_DeleteISStudent";

  Future<Map<String, dynamic>> deleteStudent(String username) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: 
          kHeader,
        
        body: jsonEncode({"username": username}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": jsonDecode(response.body)['error']};
      }
    } catch (e) {
      return {"success": false, "message": "An error occurred: $e"};
    }
  }
}

class PayeesStudentController {
  final String apiUrl = "$kUrl/FMSR_GetPayeesStudents";
  final StreamController<List<PayeesStudent>> _streamController =
      StreamController<List<PayeesStudent>>.broadcast();
  Timer? _timer;

  PayeesStudentController() {
    _startAutoRefresh();
  }

  Stream<List<PayeesStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchPayeesStudents();
    });
  }

  Future<void> _fetchPayeesStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<PayeesStudent> students = (data['data'] as List)
              .map((student) => PayeesStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load Payees Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}


class OrdinaryStudentController {
  final String apiUrl = "$kUrl/FMSR_GetOrdinaryStudents";
  final StreamController<List<OrdinaryStudent>> _streamController =
      StreamController<List<OrdinaryStudent>>.broadcast();
  Timer? _timer;

  OrdinaryStudentController() {
    _startAutoRefresh();
  }

  Stream<List<OrdinaryStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchOrdinaryStudents();
    });
  }

  Future<void> _fetchOrdinaryStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<OrdinaryStudent> students = (data['data'] as List)
              .map((student) => OrdinaryStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load Ordinary Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class GraduatesStudentController {
  final String apiUrl = "$kUrl/FMSR_GetGraduatesStudents";
  final StreamController<List<GraduatesStudent>> _streamController =
      StreamController<List<GraduatesStudent>>.broadcast();
  Timer? _timer;

  GraduatesStudentController() {
    _startAutoRefresh();
  }

  Stream<List<GraduatesStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchGraduatesStudents();
    });
  }

  Future<void> _fetchGraduatesStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<GraduatesStudent> students = (data['data'] as List)
              .map((student) => GraduatesStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load Graduates Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}


class TCPStudentController {
  final String apiUrl = "$kUrl/FMSR_GetTCPStudents";
  final StreamController<List<TCPStudent>> _streamController =
      StreamController<List<TCPStudent>>.broadcast();
  Timer? _timer;

  TCPStudentController() {
    _startAutoRefresh();
  }

  Stream<List<TCPStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchTCPStudents();
    });
  }

  Future<void> _fetchTCPStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<TCPStudent> students = (data['data'] as List)
              .map((student) => TCPStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load TCP Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class AlumniStudentController {
  final String apiUrl = "$kUrl/FMSR_GetAlumniStudents";
  final StreamController<List<AlumniStudent>> _streamController =
      StreamController<List<AlumniStudent>>.broadcast();
  Timer? _timer;

  AlumniStudentController() {
    _startAutoRefresh();
  }

  Stream<List<AlumniStudent>> get studentsStream => _streamController.stream;

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _fetchAlumniStudents();
    });
  }

  Future<void> _fetchAlumniStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: kHeader);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<AlumniStudent> students = (data['data'] as List)
              .map((student) => AlumniStudent.fromJson(student))
              .toList();
          _streamController.add(students);
        } else {
          _streamController.addError("Failed to fetch data");
        }
      } else {
        _streamController.addError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _streamController.addError("Failed to load Alumni Students: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}