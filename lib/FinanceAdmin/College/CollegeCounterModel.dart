class FMSRCollegeRequestCount {
  final int totalCount;
  final int weekCount; // This represents today's count
  final double percentageIncrease; // Percentage increase compared to yesterday
  final bool isIncreased; // Whether the count has increased or not

  FMSRCollegeRequestCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory FMSRCollegeRequestCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeRequestCount(
      totalCount: json['totalCount'],
      weekCount: json['weekCount'],
      percentageIncrease: (json['percentageIncrease'] as num).toDouble(), // Ensuring it's a double
      isIncreased: json['isIncreased'],
    );
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

class FMSRCollegeTransactionCount {
  final int totalCount;
  final int weekCount; // Represents today's count
  final double percentageIncrease;
  final bool isIncreased;

  FMSRCollegeTransactionCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  // Factory method to create an instance from a JSON map
  factory FMSRCollegeTransactionCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeTransactionCount(
      totalCount: json['totalCount'],
      weekCount: json['weekCount'],
      percentageIncrease: json['percentageIncrease'].toDouble(),
      isIncreased: json['isIncreased'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'weekCount': weekCount,
      'percentageIncrease': percentageIncrease,
      'isIncreased': isIncreased,
    };
  }
}


class FMSRCollegeStudentCount {
  final int count;

  FMSRCollegeStudentCount({required this.count});

  factory FMSRCollegeStudentCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeStudentCount(
      count: json['count'],
    );
  }
}


class SelectedStudent {
  final String? username;
  final String? fullname;
  final String? usertype;
  final String? program;
  final String? profile_image;
  final String? address;
  final String? number;
  final DateTime? birthday;

  SelectedStudent({
    this.username,
    this.fullname,
    this.usertype,
    this.profile_image,
    this.address,
    this.number,
    this.program,
    this.birthday,
  });

  factory SelectedStudent.fromJson(Map<String, dynamic> json) {
    return SelectedStudent(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      usertype: json['usertype'] as String?,
      program: json['program'] as String?,
      profile_image: json['profile_image'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profile_image,
      'address': address,
      'number': number,
      'program': program,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class CollegeRequest {
  final String username;
  final String fullname;
  final String usertype;
  final String profile_image;
  final String address;
  final String number;
  final String program;
  final DateTime? birthday;
  final DateTime date;
  final int requestCount;

  CollegeRequest({
    required this.username,
    required this.fullname,
    required this.usertype,
    required this.profile_image,
    required this.address,
    required this.number,
    required this.program,
    this.birthday, 
    required this.date,
    required this.requestCount,
  });

  // Factory constructor to create an instance from a JSON object
  factory CollegeRequest.fromJson(Map<String, dynamic> json) {
    return CollegeRequest(
      username: json['username'],
      fullname: json['fullname'],
      usertype: json['usertype'],
      profile_image: json['profile_image'],
      address: json['address'],
      number: json['number'],
      program: json['program'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      date: DateTime.parse(json['request_date']), // Parsing string to DateTime
      requestCount: json['request_count'],
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profile_image,
      'address': address,
      'number': number,
      'program': program,
      'birthday': birthday?.toIso8601String(),
      'request_date': date.toIso8601String(), // Convert DateTime to ISO string
      'request_count': requestCount,
    };
  }
}



class CollegeTransaction {
  final String username;
  final String fullname;
  final DateTime date;
  final double price;
  final List<String> documents;
  final String admin;
  final String userType;
  final int invoice;
  final String address;
  final String number;
  final DateTime birthday;  
  final String program;

  CollegeTransaction({
    required this.username,
    required this.fullname,
    required this.date,
    required this.price,
    required this.documents,
    required this.admin,
    required this.userType,
    required this.invoice,
    required this.address,
    required this.number,
    required this.birthday, 
    required this.program,
  });

 
  factory CollegeTransaction.fromJson(Map<String, dynamic> json) {
    return CollegeTransaction(
      username: json['username'],
      fullname: json['fullname'],
      date: DateTime.parse(json['date']),
      price: json['price'].toDouble(),
      documents: List<String>.from(json['documents']), // Updated key name
      admin: json['admin'],
      userType: json['usertype'],
      invoice: json['invoice'],
      address: json['address'],
      number: json['number'],
      birthday: DateTime.parse(json['birthday']),  // Non-nullable
      program: json['program'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'date': date.toIso8601String(),
      'price': price,
      'documents': documents,  // Updated key name
      'admin': admin,
      'usertype': userType,
      'invoice': invoice,
      'address': address,
      'number': number,
      'birthday': birthday.toIso8601String(), 
      'program': program,
    };
  }
}


class UserRequest {
  final String? username;
  final String? documentName;
  final double? price;
  final DateTime? date;
  final String? requirements1;
  final String? requirements2;

  UserRequest({
    this.username,
    this.documentName,
    this.price,
    this.date,
    this.requirements1,
    this.requirements2,
  });

  // Factory constructor to create a UserRequest from JSON
  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      username: json['username'] as String?,
      documentName: json['documentName'] as String?,
      price: (json['price'] != null) ? (json['price'] as num?)?.toDouble() : null,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      requirements1: json['requirements1'] as String?,
      requirements2: json['requirements2'] as String?,
    );
  }

  // Method to convert a UserRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'price': price,
      'date': date?.toIso8601String(),
      'requirements1': requirements1,
      'requirements2': requirements2,
    };
  }
}

class UserPaidDocument {
  final String? username;
  final String? documentName;
  final double? price;
  final DateTime? date;
  final String? requirements1;
  final String? requirements2;
  final int? invoice;

  UserPaidDocument({
    this.username,
    this.documentName,
    this.price,
    this.date,
    this.requirements1,
    this.requirements2,
    this.invoice,
  });

  // Factory constructor to create a UserRequest from JSON
  factory UserPaidDocument.fromJson(Map<String, dynamic> json) {
    return UserPaidDocument(
      username: json['username'] as String?,
      documentName: json['documentName'] as String?,
      price: (json['price'] != null) ? (json['price'] as num?)?.toDouble() : null,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      requirements1: json['requirements1'] as String?,
      requirements2: json['requirements2'] as String?,
      invoice: json['invoice'] != null ? json['invoice'] as int? : null,
    );
  }

  // Method to convert a UserRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'documentName': documentName,
      'price': price,
      'date': date?.toIso8601String(),
      'requirements1': requirements1,
      'requirements2': requirements2,
      'invoice': invoice,
    };
  }
}
