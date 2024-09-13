import 'dart:convert';
import 'package:flutter/material.dart';

List<StudentModel> registerModelFromJson(String str) =>
    List<StudentModel>.from(
        json.decode(str).map((x) => StudentModel.fromJson(x)));

String registerModelToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class StudentModel {
  String fullname;
  String username;
  String password;
  String usertype;

  StudentModel({
    required this.fullname,
    required this.username,
    required this.password,
    required this.usertype,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        fullname: json["fullname"],
        username: json["username"],
        password: json["password"],
        usertype: json["usertype"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "password": password,
        "usertype": usertype,
      };
}


class RegisterModel with ChangeNotifier {
  final FocusNode unfocusNode = FocusNode();

  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
 

  FocusNode? fullnameFocusNode;
  TextEditingController? fullnameTextController;

  FocusNode? typeFocusNode;
  TextEditingController? typeTextController;
  
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;

  bool _passwordVisibility = false;

  bool get passwordVisibility => _passwordVisibility;
   
  set passwordVisibility(bool value) {
    _passwordVisibility = value;
    notifyListeners();
  }

  void initState() {
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
    fullnameFocusNode?.dispose();
    fullnameTextController?.dispose();
    typeFocusNode?.dispose();
    typeTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }

  String? validateEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    // You can add more complex validation logic here if needed
    return null; // Return null if validation passes
  }

  String? validateType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Type is required';
    }
    // You can add more complex validation logic here if needed
    return null; // Return null if validation passes
  }
}


class Admin {
  String fullname;
  String firstName;
  String middleName;
  String lastName;
  String username;
  String password;
  String usertype;
  String address;
  String number;
  DateTime? birthday;  // Changed to DateTime and made nullable
  String gmail;  // Added gmail field

  Admin({
    required this.fullname,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.usertype,
    required this.address,
    required this.number,
    this.birthday,  // Made nullable
    required this.gmail,  // Added gmail
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'username': username,
      'password': password,
      'usertype': usertype,
      'address': address,
      'number': number,
      'birthday': birthday?.toIso8601String(),  // Convert DateTime to ISO 8601 string
      'gmail': gmail,
    };
  }

  // Factory constructor to create an Admin instance from JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      fullname: json['fullname'],
      firstName: json['First_Name'],
      middleName: json['Middle_Name'],
      lastName: json['Last_Name'],
      username: json['username'],
      password: json['password'],
      usertype: json['usertype'],
      address: json['address'],
      number: json['number'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,  // Parse DateTime
      gmail: json['gmail'],
    );
  }
}


class Course {
  final String acronym;
  final String program;

  Course({
    required this.acronym,
    required this.program,
  });

  // Factory method to create a Course from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      acronym: json['Acronym'] ?? '', 
      program: json['Program'] ?? '', 
    );
  }

  // Method to convert a Course to JSON
  Map<String, dynamic> toJson() {
    return {
      'Acronym': acronym,
      'Program': program,
    };
  }
}
// Function to parse a list of courses from JSON
List<Course> parseCourses(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}