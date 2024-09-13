

import 'dart:convert';

class AccomplishedDocumentsCount {
  final int totalCount;
  final int unclaimedCount;
  final int claimedCount;
  final int dailyTotalCount;
  final int dailyUnclaimedCount;
  final int dailyClaimedCount;
  final double dailyClaimedPercent;
  final double dailyUnclaimedPercent;

  AccomplishedDocumentsCount({
    required this.totalCount,
    required this.unclaimedCount,
    required this.claimedCount,
    required this.dailyTotalCount,
    required this.dailyUnclaimedCount,
    required this.dailyClaimedCount,
    required this.dailyClaimedPercent,
    required this.dailyUnclaimedPercent,
  });

  // Factory constructor to parse from JSON
  factory AccomplishedDocumentsCount.fromJson(Map<String, dynamic> json) {
    return AccomplishedDocumentsCount(
      totalCount: (json['total_count'] as int?) ?? 0,
      unclaimedCount: (json['unclaimed_count'] as int?) ?? 0,
      claimedCount: (json['claimed_count'] as int?) ?? 0,
      dailyTotalCount: (json['daily_total_count'] as int?) ?? 0,
      dailyUnclaimedCount: (json['daily_unclaimed_count'] as int?) ?? 0,
      dailyClaimedCount: (json['daily_claimed_count'] as int?) ?? 0,
      dailyClaimedPercent: double.tryParse(json['daily_claimed_percent']?.toString() ?? '0.0') ?? 0.0,
      dailyUnclaimedPercent: double.tryParse(json['daily_unclaimed_percent']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}

class Course {
  final String acronym;
  final String program;

  Course({
    required this.acronym,
    required this.program,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      acronym: json['Acronym'] ?? '', 
      program: json['Program'] ?? '', 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'Acronym': acronym,
      'Program': program,
    };
  }
}

List<Course> parseCourses(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}



class CollegeDocument {
  final String documentName;
  final double price;
  final String requirements1;
  final String requirements2;
  final String admin;

  CollegeDocument({
    required this.documentName,
    required this.price,
    required this.requirements1,
    required this.requirements2,
    required this.admin,
  });

  factory CollegeDocument.fromJson(Map<String, dynamic> json) {
    return CollegeDocument(
      documentName: json['documentName'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      requirements1: json['requirements1'],
      requirements2: json['requirements2'],
      admin: json['admin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'price': price,
      'requirements1': requirements1,
      'requirements2': requirements2,
      'admin': admin,
    };
  }
}


class CollegeDocumentRequest {
  final String username;
  final String fullname;
  final String usertype;
  final String profileImage;
  final String address;
  final String number;
  final String program;
  final DateTime birthday; // Changed type to DateTime
  final DateTime requestDate;
  final List<CollegeDocument> documents;

  CollegeDocumentRequest({
    required this.username,
    required this.fullname,
    required this.usertype,
    required this.profileImage,
    required this.address,
    required this.number,
    required this.program,
    required this.birthday,  // DateTime type
    required this.requestDate,
    required this.documents,
  });

  factory CollegeDocumentRequest.fromJson(Map<String, dynamic> json) {
    var documentsFromJson = json['documents'] as List;
    List<CollegeDocument> documentsList = documentsFromJson
        .map((doc) => CollegeDocument.fromJson(doc))
        .toList();

    return CollegeDocumentRequest(
      username: json['username'],
      fullname: json['fullname'],
      usertype: json['usertype'],
      profileImage: json['profile_image'],
      address: json['address'],
      number: json['number'],
      program: json['program'],
      birthday: DateTime.parse(json['birthday']), // Convert string to DateTime for birthday
      requestDate: DateTime.parse(json['request_date']), // Convert string to DateTime for requestDate
      documents: documentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profileImage,
      'address': address,
      'number': number,
      'program': program,
      'birthday': birthday.toIso8601String(), // Convert DateTime to string for birthday
      'request_date': requestDate.toIso8601String(), // Convert DateTime to string for requestDate
      'documents': documents.map((doc) => doc.toJson()).toList(),
    };
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

class CollegePaidDocument {
  final String username;
  final String documentName;
  final DateTime date;
  final String requirements1;
  final String requirements2;
  final String admin; // Added admin field

  CollegePaidDocument({
    required this.username,
    required this.documentName,
    required this.date,
    required this.requirements1,
    required this.requirements2,
    required this.admin, // Added admin field
  });

  // Convert the model to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
      'requirements1': requirements1,
      'requirements2': requirements2,
      'admin': admin, // Added admin field
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
      admin: json['admin'], // Added admin field
    );
  }
}
