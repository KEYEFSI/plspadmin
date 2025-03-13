class FMSRCollegeRequestCount {
  final int totalCount; // Total count of approved requests
  final int todayCount; // Represents today's count
  final double percentageChange; // Percentage change compared to yesterday
  final bool hasIncreased; // Indicates if today's count has increased compared to yesterday

  FMSRCollegeRequestCount({
    required this.totalCount,
    required this.todayCount,
    required this.percentageChange,
    required this.hasIncreased,
  });

  // Factory constructor to create an instance from a JSON map
  factory FMSRCollegeRequestCount.fromJson(Map<String, dynamic> json) {
    return FMSRCollegeRequestCount(
      totalCount: json['totalCount'] as int,
      todayCount: json['todayCount'] as int,
      percentageChange: (json['percentageChange'] as num).toDouble(),
      hasIncreased: json['hasIncreased'] as bool,
    );
  }

  // Converts the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'todayCount': todayCount,
      'percentageChange': percentageChange,
      'hasIncreased': hasIncreased,
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


class StudentCollege {
  final String? username;
  final String? fullname;
  final String? number;
  final String? address;
  final String? profile_image;
  final String? program;
  final DateTime? birthday;

  StudentCollege({
    this.username,
    this.fullname,
    this.number,
    this.address,
    this.profile_image,
    this.program,
    this.birthday,
  });

  // Factory constructor to create a Student from JSON
  factory StudentCollege.fromJson(Map<String, dynamic> json) {
    return StudentCollege(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      profile_image: json['profile_image'] as String?,
      program: json['program'] as String?,
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  // Convert Student to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'number': number,
      'address': address,
      'profile_image': profile_image,
      'program': program,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class College {
  final String? username;
  final String? fullname;
  final String? number;
  final String? address;
  final String? profile_image;
  final String? program;
  final DateTime? birthday;

  College({
    this.username,
    this.fullname,
    this.number,
    this.address,
    this.profile_image,
    this.program,
       this.birthday,
  });

  // Factory constructor to create a Student from JSON
  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      profile_image: json['profile_image'] as String?,
      program: json['program'] as String?,
       birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  // Convert Student to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'number': number,
      'address': address,
      'profile_image': profile_image,
      'program': program,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class UserTransactionDetails {
  final DateTime? date;
  final double? price;
  final int? invoice;
  final String? admin;
  final String? fullname;
  final String? address;
  final String? number;
  final DateTime? birthday;
  final List<Document>? documents;
  final double? oldBalance;
  final double? newBalance;
  final String? usertype;
  final String? program;

  UserTransactionDetails({
    this.date,
    this.price,
    this.invoice,
    this.admin,
    this.fullname,
    this.address,
    this.number,
    this.birthday,
    this.documents,
    this.oldBalance,
    this.newBalance,
    this.usertype,
    this.program,
  });

  factory UserTransactionDetails.fromJson(Map<String, dynamic> json) {
    return UserTransactionDetails(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      invoice: json['invoice'] as int?,
      admin: json['admin'] as String?,
      fullname: json['fullname'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>)
              .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
              .toList()
          : null,
      oldBalance: json['old_balance'] != null ? (json['old_balance'] as num).toDouble() : null,
      newBalance: json['new_balance'] != null ? (json['new_balance'] as num).toDouble() : null,
      usertype: json['usertype'] as String?,
      program: json['program'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'price': price,
      'invoice': invoice,
      'admin': admin,
      'fullname': fullname,
      'address': address,
      'number': number,
      'birthday': birthday?.toIso8601String(),
      'documents': documents?.map((doc) => doc.toJson()).toList(),
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'usertype': usertype,
      'program': program,
    };
  }
}

class Document {
  final String? documentName;
  final String? requirements1;
  final String? requirements2;
  final double? price;

  Document({
    this.documentName,
    this.requirements1,
    this.requirements2,
    this.price,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentName: json['documentName'] as String?,
      requirements1: json['requirements1'] as String?,
      requirements2: json['requirements2'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'requirements1': requirements1,
      'requirements2': requirements2,
      'price': price,
    };
  }
}