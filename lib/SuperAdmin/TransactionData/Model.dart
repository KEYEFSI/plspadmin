class TransactionModel {
  final String? username;
  final String? fullname;
  final DateTime? date; // Updated to DateTime
  final List<Document>? documents;
  final double? price;
  final double? oldBalance;
  final double? newBalance;
  final int? invoice;
  final String? admin;
  final String? program;
  final String? feeName;

  TransactionModel({
    this.username,
    this.fullname,
    this.date,
    this.documents,
    this.price,
    this.oldBalance,
    this.newBalance,
    this.invoice,
    this.admin,
    this.program,
    this.feeName,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null, // Parse date
      documents: (json['documents'] as List?)?.map((doc) => Document.fromJson(doc)).toList(),
      price: (json['price'] as num?)?.toDouble(),
      oldBalance: (json['old_balance'] as num?)?.toDouble(),
      newBalance: (json['new_balance'] as num?)?.toDouble(),
      invoice: json['invoice'] as int?,
      admin: json['admin'] as String?,
      program: json['program'] as String?,
      feeName: json['feename'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'date': date?.toIso8601String(), // Convert date to string
      'documents': documents?.map((doc) => doc.toJson()).toList(),
      'price': price,
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'invoice': invoice,
      'admin': admin,
      'program': program,
      'feename': feeName,
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

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentName: json['documentName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'price': price,
    };
  }
}

class Invoice {
  final int invoice;

  Invoice({required this.invoice});

  Map<String, dynamic> toJson() {
    return {'invoice': invoice};
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(invoice: json['invoice']);
  }
}

class LoginModel {
  final String username;
  final String password;

  LoginModel({required this.username, required this.password});

  // Converts the LoginModel to a Map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class Transaction {
  int? invoice;
  String? studentId;
  double? price;
  double? oldBalance;
  double? newBalance;
  String? feeName;

  Transaction({
    this.invoice,
    this.studentId,
    this.price,
    this.oldBalance,
    this.newBalance,
    this.feeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice,
      'studentid': studentId,
      'price': price,
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'feename': feeName,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      invoice: json['invoice'],
      studentId: json['studentid'],
      price: (json['price'] as num?)?.toDouble(),
      oldBalance: (json['old_balance'] as num?)?.toDouble(),
      newBalance: (json['new_balance'] as num?)?.toDouble(),
      feeName: json['feename'],
    );
  }
}
