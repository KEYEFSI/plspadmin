import 'dart:convert';

class AdminProfileModel {
  final String username;
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? password; // Be cautious with password
  final String? usertype;
  final String? profileImage;
  final String? number;
  final String? address;
  final DateTime? birthday;

  AdminProfileModel({
    required this.username,
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.password,
    this.usertype,
    this.profileImage,
    this.number,
    this.address,
    this.birthday,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      username: json['username'] as String,
      fullname: json['fullname'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      password: json['password'] as String?,
      usertype: json['usertype'] as String?,
      profileImage: json['profile_image'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'password': password, // Be cautious with password
      'usertype': usertype,
      'profile_image': profileImage,
      'number': number,
      'address': address,
      'birthday': birthday?.toIso8601String(),
    };
  }
}


class AdminUpdateModel {
  final String username;
  final String? newUsername;
  final String newPassword;

  AdminUpdateModel({
    required this.username,
    this.newUsername,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'newUsername': newUsername,
      'newPassword': newPassword,
    };
  }

  static AdminUpdateModel fromJson(Map<String, dynamic> json) {
    return AdminUpdateModel(
      username: json['username'],
      newUsername: json['newUsername'],
      newPassword: json['newPassword'],
    );
  }
}

class UpdateProfileModel {
  final String username;
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? usertype;
  final String? profileImage;
  final String? number;
  final String? address;
  final DateTime? birthday;

  UpdateProfileModel({
    required this.username,
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.usertype,
    this.profileImage,
    this.number,
    this.address,
    this.birthday,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      username: json['username'] as String,
      fullname: json['fullname'] as String?,
      firstName: json['First_Name'] as String?,
      middleName: json['Middle_Name'] as String?,
      lastName: json['Last_Name'] as String?,
      usertype: json['usertype'] as String?,
      profileImage: json['profile_image'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'usertype': usertype,
      'profile_image': profileImage,
      'number': number,
      'address': address,
      'birthday': birthday?.toIso8601String(),
    };
  }
}

