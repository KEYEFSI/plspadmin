class RejectStudentRequest {
  final String username;
  final String reason;

  RejectStudentRequest({required this.username, required this.reason});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "reason": reason,
    };
  }
}

class RejectStudentResponse {
  final bool success;
  final String message;

  RejectStudentResponse({required this.success, required this.message});

  factory RejectStudentResponse.fromJson(Map<String, dynamic> json) {
    return RejectStudentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}


class ISStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  ISStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory ISStudent.fromJson(Map<String, dynamic> json) {
    return ISStudent(
      fullname: json['fullname'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      username: json['username'] as String?,
      program: json['program'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
      birthday: json['birthday'] as String?,
      email: json['email'] as String?,
    );
  }
}


class Student {
  final String username;
  final String email;
  final String fullname;

  Student({required this.username, required this.email, required this.fullname});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      username: json['username'],
      email: json['email'],
      fullname: json['fullname'],
    );
  }
}

class PayeesStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  PayeesStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory PayeesStudent.fromJson(Map<String, dynamic> json) {
    return PayeesStudent(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      program: json['program'],
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'],
      email: json['email'],
    );
  }
}


class OrdinaryStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  OrdinaryStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory OrdinaryStudent.fromJson(Map<String, dynamic> json) {
    return OrdinaryStudent(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      program: json['program'],
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'],
      email: json['email'],
    );
  }
}

class GraduatesStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  GraduatesStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory GraduatesStudent.fromJson(Map<String, dynamic> json) {
    return GraduatesStudent(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      program: json['program'],
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'],
      email: json['email'],
    );
  }
}

class TCPStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  TCPStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory TCPStudent.fromJson(Map<String, dynamic> json) {
    return TCPStudent(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      program: json['program'],
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'],
      email: json['email'],
    );
  }
}

class AlumniStudent {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? program;
  final double? balance;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? birthday;
  final String? email;

  AlumniStudent({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.program,
    this.balance,
    this.profileImage,
    this.address,
    this.number,
    this.birthday,
    this.email,
  });

  factory AlumniStudent.fromJson(Map<String, dynamic> json) {
    return AlumniStudent(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      program: json['program'],
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'],
      email: json['email'],
    );
  }
}