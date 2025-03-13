
class ProgramModel {
  final String program;

  ProgramModel({required this.program});

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      program: json['Program'] ?? '', // Map the "Program" field to the model
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Program': program,
    };
  }
}

class ApprovedRequest {
  final String? username;
  final String? fullname;
  final String? profileImage;
  final DateTime? date;
  final String? program;
  final List<Request>? requests;

  ApprovedRequest({
    this.username,
    this.fullname,
    this.profileImage,
    this.date,
    this.program,
    this.requests,
  });

  factory ApprovedRequest.fromJson(Map<String, dynamic> json) {
    return ApprovedRequest(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      profileImage: json['profile_image'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      program: json['program'] as String?,
      requests: (json['requests'] as List<dynamic>?)
          ?.map((request) => Request.fromJson(request))
          .toList(),
    );
  }
}

class Request {
  final String? documentName;
  final double? price;
  final String? requirements1;
  final String? requirements2;
  final String? email;
  final String? number;

  Request({
    this.documentName,
    this.price,
    this.requirements1,
    this.requirements2,
    this.email,
    this.number,
  });

  // Add the toJson method
  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'price': price,
      'requirements1': requirements1,
      'requirements2': requirements2,
      // You can skip email and number as they are not needed
    };
  }

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      documentName: json['documentName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      requirements1: json['requirements1'] as String?,
      requirements2: json['requirements2'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
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

class TransactionModel {
  final String username;
  final String fullname;
  final DateTime date; // Changed to DateTime
  final double price;
  final List<dynamic> documents;
  final String admin;
  final int invoice;
  final String program;

  TransactionModel({
    required this.username,
    required this.fullname,
    required this.date,
    required this.price,
    required this.documents,
    required this.admin,
    required this.invoice,
    required this.program,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'date': date.toIso8601String(), // Converts DateTime to ISO 8601 string
      'price': price,
      'documents': documents,
      'admin': admin,
      'invoice': invoice,
      'program': program,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      username: json['username'],
      fullname: json['fullname'],
      date: DateTime.parse(json['date']), // Parses ISO 8601 string to DateTime
      price: json['price'],
      documents: json['documents'],
      admin: json['admin'],
      invoice: json['invoice'],
      program: json['program'],
    );
  }
}


class UpdateToPaidRequest {
  final String username;
  final String documentName;
  final DateTime date;
  final String email;

  UpdateToPaidRequest({
    required this.username,
    required this.documentName,
    required this.date,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "documentName": documentName,
        "date": date.toIso8601String(), // Convert DateTime to ISO 8601 string for JSON
        "email": email,
      };

  static UpdateToPaidRequest fromJson(Map<String, dynamic> json) {
    return UpdateToPaidRequest(
      username: json['username'],
      documentName: json['documentName'],
      date: DateTime.parse(json['date']), // Parse ISO 8601 string into DateTime
      email: json['email'],
    );
  }
}