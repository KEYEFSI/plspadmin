

import 'dart:convert';


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

class PendingDocumentRequest {
  final String username;
  final String fullname;
  final String program;
  final String documentName;
  final double price;
  final DateTime date;
  final String requirements1;
  final String requirements2;
  final String status;
  final String email;
  final String number;
  final String profileImage;
  final int stamp; 

  PendingDocumentRequest({
    required this.username,
    required this.fullname,
    required this.program,
    required this.documentName,
    required this.price,
    required this.date,
    required this.requirements1,
    required this.requirements2,
    required this.status,
    required this.email,
    required this.number,
    required this.profileImage,
    required this.stamp, 
  });

  factory PendingDocumentRequest.fromJson(Map<String, dynamic> json) {
    return PendingDocumentRequest(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      program: json['program'] ?? '',
      documentName: json['documentName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      requirements1: json['requirements1'] ?? '',
      requirements2: json['requirements2'] ?? '',
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      profileImage: json['profile_image'] ?? '',
      stamp: json['Stamp'] ?? 0, 
    );
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
  final DateTime date; 
  String? fullname;
  String? program;
  double? price;
  String? requirements1;
  String? requirements2;
  String? email; 
  String? stampcode;

  DocumentRequest({
    required this.username,
    required this.documentName,
    required this.date, 
    this.fullname,
    this.program,
    this.price,
    this.requirements1,
    this.requirements2,
    this.email, 
    this.stampcode,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "documentName": documentName,
      "date": date.toIso8601String(),
      "fullname": fullname,
      "program": program,
      "price": price,
      "requirements1": requirements1,
      "requirements2": requirements2,
      "email": email,
      "stampcode": stampcode,
    };
  }

  factory DocumentRequest.fromJson(Map<String, dynamic> json) {
    return DocumentRequest(
      username: json['username'],
      documentName: json['documentName'],
      date: DateTime.parse(json['date']),
      fullname: json['fullname'],
      program: json['program'],
      price: json['price'],
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      email: json['email'],
      stampcode: json['stampcode'],
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


class DocumentStatistics {
  final String status;
  final int count;
  final String percentage;

  DocumentStatistics({
    required this.status,
    required this.count,
    required this.percentage,
  });

  factory DocumentStatistics.fromJson(Map<String, dynamic> json) {
    return DocumentStatistics(
      status: json['status'],
      count: json['count'],
      percentage: json['percentage'],
    );
  }
}

class DocumentStatisticsResponse {
  final String date;
  final int totalCount;
  final int pendingCount;
  final String pendingPercentage;
  final int approvedCount;
  final String approvedPercentage;
  final int rejectedCount;
  final String rejectedPercentage;

  DocumentStatisticsResponse({
    required this.date,
    required this.totalCount,
    required this.pendingCount,
    required this.pendingPercentage,
    required this.approvedCount,
    required this.approvedPercentage,
    required this.rejectedCount,
    required this.rejectedPercentage,
  });

  factory DocumentStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentStatisticsResponse(
      date: json['date'],
      totalCount: json['totalCount'],
      pendingCount: json['PendingCount'],
      pendingPercentage: json['PendingPercentage'],
      approvedCount: json['ApprovedCount'],
      approvedPercentage: json['ApprovedPercentage'],
      rejectedCount: json['RejectedCount'],
      rejectedPercentage: json['RejectedPercentage'],
    );
  }
}


class Stamp {
  final String stamp;
  final double price;

  Stamp({required this.stamp, required this.price});

  factory Stamp.fromJson(Map<String, dynamic> json) {
    return Stamp(
      stamp: json['Stamp'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}