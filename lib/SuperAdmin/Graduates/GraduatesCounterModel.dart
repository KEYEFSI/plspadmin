
class FMSRGraduatesRequestsCount {
  final int totalCount;
  final int weekCount;
  final double percentageIncrease;
  final bool isIncreased;

  FMSRGraduatesRequestsCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory FMSRGraduatesRequestsCount.fromJson(Map<String, dynamic> json) {
    try {
      return FMSRGraduatesRequestsCount(
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


class FMSRGraduatesTransactionCounter {
  final int totalCount;
  final int weekCount; // Represents today's count
  final double percentageIncrease;
  final bool isIncreased;

  FMSRGraduatesTransactionCounter({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  // Factory method to create an instance from a JSON map
  factory FMSRGraduatesTransactionCounter.fromJson(Map<String, dynamic> json) {
    return FMSRGraduatesTransactionCounter(
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

class StudentGrad {
  final String? username;
  final String? fullname;
  final String? number;
  final String? address;
  final String? profile_image;
  final double? balance;
  final DateTime? birthday;

  StudentGrad({
    this.username,
    this.fullname,
    this.number,
    this.address,
    this.profile_image,
    this.balance,
    this.birthday,
  });

  // Factory constructor to create a Student from JSON
  factory StudentGrad.fromJson(Map<String, dynamic> json) {
    return StudentGrad(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      profile_image: json['profile_image'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
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
      'balance': balance,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class Graduates {
  final String? username;
  final String? fullname;
  final String? number;
  final String? address;
  final String? profile_image;
  final double? balance;
  final DateTime? birthday;

  Graduates({
    this.username,
    this.fullname,
    this.number,
    this.address,
    this.profile_image,
    this.balance,
    this.birthday,
  });

  // Factory constructor to create a Student from JSON
  factory Graduates.fromJson(Map<String, dynamic> json) {
    return Graduates(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      profile_image: json['profile_image'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
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
      'balance': balance,
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
  final List<Document>? documents; // Updated to handle list of documents
  final double? oldBalance;
  final double? newBalance;
  final String? usertype;
  final String? program;
  final String? feeName; // New field for fee_name

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
    this.feeName, // Initialize the feeName field
  });

  // Factory method to create an instance from JSON
  factory UserTransactionDetails.fromJson(Map<String, dynamic> json) {
    return UserTransactionDetails(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      invoice: json['invoice'],
      admin: json['admin'],
      fullname: json['fullname'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>)
              .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
              .toList()
          : null,
      oldBalance: json['old_balance'] != null ? (json['old_balance'] as num).toDouble() : null,
      newBalance: json['new_balance'] != null ? (json['new_balance'] as num).toDouble() : null,
      usertype: json['usertype'],
      program: json['program'],
      feeName: json['fee_name'], // Parse feeName from JSON
    );
  }

  // Method to convert a UserTransactionDetails instance to JSON
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
      'fee_name': feeName, // Convert feeName to JSON
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

  // Factory constructor to create a Document from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentName: json['Document_Name'] as String?,
      requirements1: json['Requirements1'] as String?,
      requirements2: json['Requirements2'] as String?,
      price: (json['Price'] as num?)?.toDouble(),
    );
  }

  // Convert Document to JSON
  Map<String, dynamic> toJson() {
    return {
      'Document_Name': documentName,
      'Requirements1': requirements1,
      'Requirements2': requirements2,
      'Price': price,
    };
  }
}
