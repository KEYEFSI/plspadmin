


import 'package:intl/intl.dart';

class FMSRGraduatesStudentCount {
  final int count;

  FMSRGraduatesStudentCount({required this.count});

  factory FMSRGraduatesStudentCount.fromJson(Map<String, dynamic> json) {
    return FMSRGraduatesStudentCount(
      count: json['count'],
    );
  }
}
class FMSRGraduatesRequestCount {
  final int totalCount;
  final int weekCount;
  final double percentageIncrease;
  final bool isIncreased;

  FMSRGraduatesRequestCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory FMSRGraduatesRequestCount.fromJson(Map<String, dynamic> json) {
    try {
      return FMSRGraduatesRequestCount(
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


class FMSRGraduatesTransactionCount {
  final int totalCount;
  final int weekCount;
  final double percentageIncrease;
  final bool isIncreased;

  FMSRGraduatesTransactionCount({
    required this.totalCount,
    required this.weekCount,
    required this.percentageIncrease,
    required this.isIncreased,
  });

  factory FMSRGraduatesTransactionCount.fromJson(Map<String, dynamic> json) {
    try {
      return FMSRGraduatesTransactionCount(
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






class SelectedStudent {
  final String? username;
  final String? fullname;
  final String? usertype;
  final String? profile_image;
  final String? address;
  final String? number;
  final double? balance;
    final DateTime? birthday;


  SelectedStudent({
    this.username,
    this.fullname,
    this.usertype,
    this.profile_image,
    this.address,
    this.number,
    this.balance,
        this.birthday,
  });

  factory SelectedStudent.fromJson(Map<String, dynamic> json) {
    return SelectedStudent(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      usertype: json['usertype'] as String?,
      profile_image: json['profile_image'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
       birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
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
      'balance': balance,
      'birthday': birthday?.toIso8601String(),
    };
  }
}


class GraduatesStudent {
  final String username;
  final String fullname;
  final String usertype;
  final String profile_image;
  final String address;
  final String number;
  final double balance;
  final DateTime date;
  final DateTime? birthday;
  

  GraduatesStudent({
    required this.username,
    required this.fullname,
    required this.usertype,
    required this.profile_image,
    required this.address,
    required this.number,
    required this.balance,
    required this.date,
    this.birthday,
  });

  factory GraduatesStudent.fromJson(Map<String, dynamic> json) {
    return GraduatesStudent(
      username: json['username'],
      fullname: json['fullname'],
      usertype: json['usertype'],
      profile_image: json['profile_image'],
      address: json['address'],
      number: json['number'],
      balance: (json['balance'] as num).toDouble(),
      date: DateTime.parse(json['date']),
       birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
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
      'balance': balance,
      'date': date.toIso8601String(),
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class TransactionModel {
  final String username;
  final String fullname;
  final DateTime date;
  final double price;
  final double oldBalance;
  final double newBalance;
  final String admin;
  final String usertype;
  final int invoice;
  final String address;
  final String number;
  final DateTime? birthday;

  TransactionModel({
    required this.username,
    required this.fullname,
    required this.date,
    required this.price,
    required this.oldBalance,
    required this.newBalance,
    required this.admin,
    required this.usertype,
    required this.invoice,
    required this.address,
    required this.number,
    required this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'date': date.toIso8601String(),
      'price': price,
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'admin': admin,
      'usertype': usertype,
      'invoice': invoice,
      'address': address,
      'number': number,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

class UpdatePaidStatusRequest {
  final String username;
  final DateTime date;

  UpdatePaidStatusRequest({
    required this.username,
    required this.date,
  });

  // Convert a JSON map into an instance of UpdatePaidStatusRequest
  factory UpdatePaidStatusRequest.fromJson(Map<String, dynamic> json) {
    return UpdatePaidStatusRequest(
      username: json['username'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
    );
  }

  // Convert an instance of UpdatePaidStatusRequest into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'date': DateFormat('yyyy-MM-dd').format(date), // Format DateTime as yyyy-MM-dd
    };
  }
}
