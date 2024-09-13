

import 'dart:convert';

class FMSRCollegeStudentCount {
  final int count;

  FMSRCollegeStudentCount({required this.count});

  factory FMSRCollegeStudentCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeStudentCount(
      count: json['count'],
    );
  }
}

class PendingCount {
  final int totalCount;
  final int weekCount;
  final double percentageIncrease;
  final bool isIncreased;

  PendingCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  // Factory method to create a PendingCount instance from JSON
  factory PendingCount.fromJson(Map<String, dynamic> json) {
    return PendingCount(
      totalCount: json['totalCount'] ?? 0,
      weekCount: json['weekCount'] ?? 0,
      percentageIncrease: (json['percentageIncrease'] ?? 0).toDouble(),
      isIncreased: json['isIncreased'] ?? false,
    );
  }
}


class AccomplishedCount {
  final int totalCount;
  final int weekCount;
  final double percentageIncrease;
  final bool isIncreased;

  AccomplishedCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory AccomplishedCount.fromJson(Map<String, dynamic> json) {
    try {
      return AccomplishedCount(
        totalCount: json['totalCount'] ?? 0,
        weekCount: json['weekCount'] ?? 0,
        percentageIncrease: (json['percentageIncrease'] as num).toDouble(),
        isIncreased: json['percentageIncrease'] >= 0,  
      );
    } catch (e) {
      print('Error parsing AccomplishedCount: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'weekCount': weekCount,
      'percentageIncrease': percentageIncrease,
      'isIncreased': isIncreased,
    };
  }
}



class Course {
  final String acronym;
  final String program;

  Course({
    required this.acronym,
    required this.program,
  });

  // Factory method to create a Course from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      acronym: json['Acronym'] ?? '', 
      program: json['Program'] ?? '', 
    );
  }

  // Method to convert a Course to JSON
  Map<String, dynamic> toJson() {
    return {
      'Acronym': acronym,
      'Program': program,
    };
  }
}
// Function to parse a list of courses from JSON
List<Course> parseCourses(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}


class CollegeDocumentRequest {
  final String username;
  final String fullname;
  final String usertype;
  final String profileImage;
  final String address;
  final String number;
  final String program;
  final DateTime? birthday;
  final DateTime? requestDate; // Nullable DateTime
  final List<Document> documents;

  CollegeDocumentRequest({
    required this.username,
    required this.fullname,
    required this.usertype,
    required this.profileImage,
    required this.address,
    required this.number,
    required this.program,
    this.birthday,
    this.requestDate, // Nullable
    required this.documents,
  });

  factory CollegeDocumentRequest.fromJson(Map<String, dynamic> json) {
    var documentsList = json['documents'] as List;
    List<Document> documentItems = documentsList.map((doc) => Document.fromJson(doc)).toList();

    return CollegeDocumentRequest(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      usertype: json['usertype'] ?? '',
      profileImage: json['profile_image'] ?? '',
      address: json['address'] ?? '',
      number: json['number'] ?? '',
      program: json['program'] ?? '',
      birthday:  json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null,
      requestDate: json['request_date'] != null ? DateTime.tryParse(json['request_date']) : null,
      documents: documentItems,
    );
  }
}

class Document {
  final String documentName;
  final double price;
  final String requirements1;
  final String requirements2;
  final int invoice;

  Document({
    required this.documentName,
    required this.price,
    required this.requirements1,
    required this.requirements2,
    required this.invoice,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentName: json['documentName'] ?? '',
      price: (json['price'] as num).toDouble(),
      requirements1: json['requirements1'] ?? '',
      requirements2: json['requirements2'] ?? '',
      invoice: (json['invoice'] as num).toInt(),
    );
  }
}

class DocumentList {
  final String documentName;
  final String requirements1;
  final String requirements2;
  final double price;

  DocumentList({
    required this.documentName,
    required this.requirements1,
    required this.requirements2,
    required this.price,
  });

  factory DocumentList.fromJson(Map<String, dynamic> json) {
    return DocumentList(
      documentName: json['Document_Name'] as String,
      requirements1: json['Requirements1'] as String,
      requirements2: json['Requirements2'] as String,
      price: (json['Price'] as num).toDouble(),
    );
  }
}

class CollegeAccomplishedDocument {
  final String username;
  final String documentName;
  final double price;
  final DateTime date;
  final String requirements1;
  final String requirements2;
  final bool claimed; // Added field
  final String admin; // Added field

  CollegeAccomplishedDocument({
    required this.username,
    required this.documentName,
    required this.price,
    required this.date,
    required this.requirements1,
    required this.requirements2,
    required this.claimed, // Added field
    required this.admin,   // Added field
  });

  // Convert a CollegeAccomplishedDocument instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'price': price,
      'date': date.toIso8601String(),
      'requirements1': requirements1,
      'requirements2': requirements2,
      'claimed': claimed ? 1 : 0, // Convert bool to int for JSON
      'admin': admin,
    };
  }

  // Convert JSON to a CollegeAccomplishedDocument instance
  factory CollegeAccomplishedDocument.fromJson(Map<String, dynamic> json) {
    return CollegeAccomplishedDocument(
      username: json['username'],
      documentName: json['documentName'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      claimed: json['claimed'] == 1, // Convert int to bool
      admin: json['admin'],
    );
  }
}



class CollegePaidDocument {
  final String username;
  final String documentName;
  final DateTime date;
  final String requirements1;
  final String requirements2;
  final int invoice;

  CollegePaidDocument({
    required this.username,
    required this.documentName,
    required this.date,
    required this.requirements1,
    required this.requirements2,
    required this.invoice,
  });

  // Convert the model to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
      'requirements1': requirements1,
      'requirements2': requirements2,
      'invoice': invoice,
    };
  }

  // Create a CollegePaidDocument instance from JSON
  factory CollegePaidDocument.fromJson(Map<String, dynamic> json) {
    return CollegePaidDocument(
      username: json['username'],
      documentName: json['documentName'],
      date: DateTime.parse(json['date']),
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      invoice: json['invoice'],
    );
  }
}

