import 'dart:convert';
import 'package:intl/intl.dart';

class ProgramWindowModel {
  final String windowName;
  final List<String> programs;

  ProgramWindowModel({required this.windowName, required this.programs});

  factory ProgramWindowModel.fromJson(Map<String, dynamic> json) {
    final windowName = json['windowName'].toString();

    // Handle programs as either a JSON array or a stringified array
    final programsField = json['programs'];
    List<String> programs;

    if (programsField is String) {
      try {
        programs = List<String>.from(jsonDecode(programsField));
      } catch (e) {
        programs = [programsField];
      }
    } else if (programsField is List) {
      programs = programsField.map((item) => item.toString()).toList();
    } else {
      programs = [];
    }

    return ProgramWindowModel(
      windowName: windowName,
      programs: programs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'windowName': windowName,
      'programs': programs,
    };
  }
}

class StudentModel {
  final String fullname;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String userType;
  final String program;
  final double balance;
  final String? profileImage;
  final String address;
  final String number;
  final DateTime birthday;
  final String email;

  StudentModel({
    required this.fullname,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.userType,
    required this.program,
    required this.balance,
    this.profileImage,
    required this.address,
    required this.number,
    required this.birthday,
    required this.email,
  });

  // Factory constructor to create an instance from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      fullname: json['fullname'],
      firstName: json['First_Name'],
      middleName: json['Middle_Name'],
      lastName: json['Last_Name'],
      username: json['username'],
      userType: json['usertype'],
      program: json['program'],
      balance: double.parse(json['balance'].toString()),
      profileImage: json['profile_image'],
      address: json['address'],
      number: json['number'],
      birthday: DateTime.parse(json['birthday']),
      email: json['email'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'username': username,
      'usertype': userType,
      'program': program,
      'balance': balance,
      'profile_image': profileImage,
      'address': address,
      'number': number,
      'birthday': birthday.toIso8601String(),
      'email': email,
    };
  }
}


class Document {
  final String? documentName;
  final double? price;
  final String? requirements1;
  final String? requirements2;
  final String? hint1;
  final String? hint2;

  Document({
    this.documentName,
    this.price,
    this.requirements1,
    this.requirements2,
    this.hint1,
    this.hint2,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // Adjusted to handle nested response structure
    return Document(
      documentName: data['Document_Name'],
      price: data['Price'] != null ? data['Price'].toDouble() : null,
      requirements1: data['Requirements1'],
      requirements2: data['Requirements2'],
      hint1: data['Hint1'],
      hint2: data['Hint2'],
    );
  }
}

class DocumentRequest {
  final String username;
  final String documentName;
  final DateTime date; // Use DateTime for date field
  String? fullname;
  String? program;
  double? price;
  String? requirements1;
  String? requirements2;
  String? email;
  String? status;
  String? window; // Assuming 'window' is a field in the request.
  DateTime? obtainedDate; // New field for Obtained_Date
  String? adminAssigned; // New field for Admin_Assigned

  DocumentRequest({
    required this.username,
    required this.documentName,
    required this.date, // DateTime parameter
    this.fullname,
    this.program,
    this.price,
    this.requirements1,
    this.requirements2,
    this.email,
    this.status,
    this.window, // Include window in constructor
    this.obtainedDate, // Include Obtained_Date in constructor
    this.adminAssigned, // Include Admin_Assigned in constructor
  });

  // Convert DateTime to ISO8601 String in JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "documentName": documentName,
      "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(date), // Format date
      "fullname": fullname,
      "program": program,
      "price": price,
      "requirements1": requirements1,
      "requirements2": requirements2,
      "email": email,
      "status": status,
      "window": window, // Include window in toJson method
      "obtainedDate": obtainedDate != null
          ? DateFormat("yyyy-MM-dd HH:mm:ss").format(obtainedDate!)
          : null, // Format obtainedDate
      "adminAssigned": adminAssigned, // Include Admin_Assigned
    };
  }

  // Factory method to parse JSON into a DocumentRequest object
  factory DocumentRequest.fromJson(Map<String, dynamic> json) {
    return DocumentRequest(
      username: json['username'],
      documentName: json['documentName'],
      date: DateTime.parse(json['date']),
      fullname: json['fullname'],
      program: json['program'],
      price: (json['price'] as num?)?.toDouble(),
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      email: json['email'],
      status: json['status'],
      window: json['window'], // Parse window
      obtainedDate: json['obtainedDate'] != null
          ? DateTime.parse(json['obtainedDate'])
          : null, // Parse obtainedDate
      adminAssigned: json['adminAssigned'], // Parse adminAssigned
    );
  }
}


// Flutter Model for Reject Document Request
class RejectDocumentRequest {
  final String username;
  final String documentName;
  final DateTime date;
  final String email;
  final String reason; // Renamed for clarity and backend alignment

  RejectDocumentRequest({
    required this.username,
    required this.documentName,
    required this.date,
    required this.email,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'date': date.toIso8601String(), // Ensure the date is in ISO8601 format
      'email': email,
      'rejectionReason': reason, // Updated key to match backend
    };
  }

  factory RejectDocumentRequest.fromJson(Map<String, dynamic> json) {
    return RejectDocumentRequest(
      username: json['username'],
      documentName: json['documentName'],
      date: DateTime.parse(json['date']),
      email: json['email'],
      reason: json['rejectionReason'],
    );
  }
}

class DocumentStatisticsResponse {
  final String date;
  final int totalCount;
  final int paidCount;
  final String paidPercentage;
  final int completedCount;
  final String completedPercentage;
  final int obtainedCount;
  final String obtainedPercentage;

  DocumentStatisticsResponse({
    required this.date,
    required this.totalCount,
    required this.paidCount,
    required this.paidPercentage,
    required this.completedCount,
    required this.completedPercentage,
    required this.obtainedCount,
    required this.obtainedPercentage,
  });

  factory DocumentStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentStatisticsResponse(
      date: json['date'],
      totalCount: json['totalCount'],
      paidCount: json['PaidCount'],
      paidPercentage: json['PaidPercentage'],
      completedCount: json['CompletedCount'],
      completedPercentage: json['CompletedPercentage'],
      obtainedCount: json['ObtainedCount'],
      obtainedPercentage: json['ObtainedPercentage'],
    );
  }
}


class ObtainedRequest {
  final String username;
  final String fullname;
  final String program;
  final String documentName;
  final double price;
  final DateTime? date; // Nullable DateTime
  final String? requirements1;
  final String? requirements2;
  final String status;
  final DateTime? obtainedDate; // Nullable DateTime
  final String? adminAssigned;

  ObtainedRequest({
    required this.username,
    required this.fullname,
    required this.program,
    required this.documentName,
    required this.price,
    this.date, // Nullable
    this.requirements1,
    this.requirements2,
    required this.status,
    this.obtainedDate, // Nullable
    this.adminAssigned,
  });

  // Factory method to create an instance from JSON
  factory ObtainedRequest.fromJson(Map<String, dynamic> json) {
    return ObtainedRequest(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      program: json['program'] ?? '',
      documentName: json['documentName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null, // Try parse or null
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      status: json['status'] ?? '',
      obtainedDate: json['Obtained_Date'] != null
          ? DateTime.tryParse(json['Obtained_Date'])
          : null, // Try parse or null
      adminAssigned: json['Admin_Assigned'],
    );
  }
}
