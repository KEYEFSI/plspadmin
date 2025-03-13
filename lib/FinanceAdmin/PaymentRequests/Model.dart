
class UnpaidRequest {
  final String? username;
  final String? fullname;
  final String? feeName;
  final double? price;
  final double? oldBalance;
  final double? newBalance;
  final DateTime? date; // Changed to DateTime
  final String? status;
  final String? invoiceNo; // Considered as String
  final String? adminAssigned;
  final String? profileImage;
  final String? address;
  final String? number;
  final DateTime? birthday; // Changed to DateTime
  final String? email;
  final String? usertype;
  final double? balance;

  UnpaidRequest({
    this.username,
    this.fullname,
    this.feeName,
    this.price,
    this.oldBalance,
    this.newBalance,
    this.date,
    this.status,
    this.invoiceNo,
    this.adminAssigned,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
    this.usertype,
    this.balance,
  });

  factory UnpaidRequest.fromJson(Map<String, dynamic> json) {
    return UnpaidRequest(
      username: json['username'],
      fullname: json['fullname'],
      feeName: json['feeName'],
      price: (json['price'] as num?)?.toDouble(),
      oldBalance: (json['oldBalance'] as num?)?.toDouble(),
      newBalance: (json['newBalance'] as num?)?.toDouble(),
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null, // Parse to DateTime
      status: json['status'],
      invoiceNo: json['InvoiceNo']?.toString(), // Ensure it's a string
      adminAssigned: json['Admin_Assigned'],
      profileImage: json['profile_image'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null, // Parse to DateTime
      email: json['email'],
      usertype: json['usertype'],
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'feeName': feeName,
      'price': price,
      'oldBalance': oldBalance,
      'newBalance': newBalance,
      'date': date?.toIso8601String(), // Convert to ISO8601 String
      'status': status,
      'InvoiceNo': invoiceNo,
      'Admin_Assigned': adminAssigned,
      'profile_image': profileImage,
      'address': address,
      'number': number,
      'birthday': birthday?.toIso8601String(), // Convert to ISO8601 String
      'email': email,
      'usertype': usertype,
      'balance': balance,
    };
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
  final DateTime date;
  final double price;
  final double oldBalance;
  final double newBalance;
  final String admin;
  final int invoice;
  final String feename;

  TransactionModel({
    required this.username,
    required this.fullname,
    required this.date,
    required this.price,
    required this.oldBalance,
    required this.newBalance,
    required this.admin,
    required this.invoice,
    required this.feename,
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
      'invoice': invoice,
      'feename': feename,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      username: json['username'],
      fullname: json['fullname'],
      date: DateTime.parse(json['date']),
      price: json['price'],
      oldBalance: json['old_balance'],
      newBalance: json['new_balance'],
      admin: json['admin'],
      invoice: json['invoice'],
      feename: json['feename'],
    );
  }
}


class PaymentRequest {
  final String username;
  final String feeName;
  final double price;
  final double oldBalance;
  final double newBalance;
  final int invoiceNo;
  final String adminAssigned;
  final DateTime date;
  final String email; // Add email field

  PaymentRequest({
    required this.username,
    required this.feeName,
    required this.price,
    required this.oldBalance,
    required this.newBalance,
    required this.invoiceNo,
    required this.adminAssigned,
    required this.date,
    required this.email, // Initialize email
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'feeName': feeName,
        'price': price,
        'oldBalance': oldBalance,
        'newBalance': newBalance,
        'invoiceNo': invoiceNo,
        'adminAssigned': adminAssigned,
        'date': date.toIso8601String(),
        'email': email, // Include email in JSON
      };

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      username: json['username'],
      feeName: json['feeName'],
      price: json['price'],
      oldBalance: json['oldBalance'],
      newBalance: json['newBalance'],
      invoiceNo: json['invoiceNo'],
      adminAssigned: json['adminAssigned'],
      date: DateTime.parse(json['date']),
      email: json['email'], // Parse email from JSON
    );
  }
}
