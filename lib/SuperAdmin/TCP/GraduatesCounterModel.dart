import 'dart:convert';



class FeeModel {
  final String feeName;

  FeeModel({required this.feeName});

  Map<String, dynamic> toJson() {
    return {'feeName': feeName};
  }
}


class AddFeeModel {
  final String feeName;

  AddFeeModel({required this.feeName});

  // Convert AddFeeModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'FeeName': feeName,  // Ensure uppercase to match backend
    };
  }

  // Create AddFeeModel object from JSON
  factory AddFeeModel.fromJson(Map<String, dynamic> json) {
    return AddFeeModel(
      feeName: json['FeeName'] ?? '',  // Handle null safely
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Fee {
  final String feeName;

  Fee({
    required this.feeName,
  });

  // Factory method to create a Fee from JSON
  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      feeName: json['FeeName'] ?? '', // Handle null with default value
    );
  }

  // Method to convert a Fee to JSON
  Map<String, dynamic> toJson() {
    return {
      'FeeName': feeName,
    };
  }
}

// Function to parse a list of fees from JSON
List<Fee> parseFees(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Fee>((json) => Fee.fromJson(json)).toList();
}


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

class Student {
  final String? username;
  final String? fullname;
  final String? number;
  final String? address;
  final String? profile_image;
  final double? balance;
  final DateTime? birthday;

  Student({
    this.username,
    this.fullname,
    this.number,
    this.address,
    this.profile_image,
    this.balance,
    this.birthday,
  });

  // Factory constructor to create a Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
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

class TransactionData {
  final DateTime? date;
  final double? price;
  final int? invoice;
  final String? admin;
  final String? fullname;
  final String? program;
  final String? feeName;
  final List<Document>? documents;
  final double? oldBalance;
  final double? newBalance;

  TransactionData({
    this.date,
    this.price,
    this.invoice,
    this.admin,
    this.fullname,
    this.program,
    this.feeName,
    this.documents,
    this.oldBalance,
    this.newBalance,
  });

  // Factory method to create an instance from JSON
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      invoice: json['invoice'],
      admin: json['admin'],
      fullname: json['fullname'],
      program: json['program'],
      feeName: json['feename'],
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>)
              .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
              .toList()
          : null,
      oldBalance: json['old_balance'] != null
          ? (json['old_balance'] as num).toDouble()
          : null,
      newBalance: json['new_balance'] != null
          ? (json['new_balance'] as num).toDouble()
          : null,
    );
  }

  // Convert a TransactionData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'price': price,
      'invoice': invoice,
      'admin': admin,
      'fullname': fullname,
      'program': program,
      'feename': feeName,
      'documents': documents?.map((doc) => doc.toJson()).toList(),
      'old_balance': oldBalance,
      'new_balance': newBalance,
    };
  }
}

class Document {
  final String? documentName;
  final double? price;

  Document({
    this.documentName,
    this.price,
  });

  // Factory constructor to create a Document from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentName: json['documentName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  // Convert Document to JSON
  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'price': price,
    };
  }
}



class PayeesData {
  final TransactionDatas transaction;
  final StudentData student;
  final RequestData requests;

  PayeesData({
    required this.transaction,
    required this.student,
    required this.requests,
  });

  factory PayeesData.fromJson(Map<String, dynamic> json) {
    return PayeesData(
      transaction: TransactionDatas.fromJson(json['transaction']),
      student: StudentData.fromJson(json['student']),
      requests: RequestData.fromJson(json['requests']),
    );
  }
}

class TransactionDatas {
  final double totalCount;
  final double dailyCount;
  final double percentageIncrease;
  final bool isIncreased;

  TransactionDatas({
    required this.totalCount,
    required this.dailyCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory TransactionDatas.fromJson(Map<String, dynamic> json) {
    return TransactionDatas(
      totalCount: (json['totalCount'] as num).toDouble(), // Convert int to double if necessary
      dailyCount: (json['dailyCount'] as num).toDouble(),
      percentageIncrease: (json['percentageIncrease'] as num).toDouble(),
      isIncreased: json['isIncreased'] as bool,
    );
  }
}

class StudentData {
  final double totalCount;

  StudentData({
    required this.totalCount,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      totalCount: (json['totalCount'] as num).toDouble(),
    );
  }
}

class RequestData {
  final double unpaidCount;
  final double dailyUnpaidCount;
  final double percentageIncrease;
  final bool isIncreased;

  RequestData({
    required this.unpaidCount,
    required this.dailyUnpaidCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      unpaidCount: (json['unpaidCount'] as num).toDouble(),
      dailyUnpaidCount: (json['dailyUnpaidCount'] as num).toDouble(),
      percentageIncrease: (json['percentageIncrease'] as num).toDouble(),
      isIncreased: json['isIncreased'] as bool,
    );
  }
}


