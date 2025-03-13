class DeleteStudentRequest {
  final String username;
  final String reason;

  DeleteStudentRequest({required this.username, required this.reason});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "reason": reason,
    };
  }
}

class DeleteStudentResponse {
  final bool success;
  final String message;

  DeleteStudentResponse({required this.success, required this.message});

  factory DeleteStudentResponse.fromJson(Map<String, dynamic> json) {
    return DeleteStudentResponse(
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
  final String? usertype;
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
    this.usertype,
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