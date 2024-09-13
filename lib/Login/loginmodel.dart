import 'dart:convert';
import 'package:flutter/material.dart';



List<StudentModel> loginModelFromJson(String str) =>
    List<StudentModel>.from(json.decode(str).map((x) => StudentModel.fromJson(x)));

String loginModelToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentModel {
  String username;
  String password;
  String usertype;

  StudentModel({
    required this.username,
    required this.password,
    required this.usertype,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        username: json["username"],
        password: json["password"],
        usertype: json["usertype"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "usertype": usertype,
      };
}




class LoginModel with ChangeNotifier {
  /// State fields for stateful widgets in this page.

  final FocusNode unfocusNode = FocusNode();

  // State fields for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;

  get scaffoldKey => null;
  String? validateEmailAddress(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email address is required';
  }
  // You can add more complex validation logic here if needed
  return null; // Return null if validation passes
}

  // State fields for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  bool _passwordVisibility = false;
  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  // You can add more complex validation logic here if needed
  return null; // Return null if validation passes
}


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
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}

T createModel<T>(BuildContext context, T Function() modelCreator) {
  return modelCreator();
}

class Loginmodel {
    String email;
    String password;
    String type;

    Loginmodel({
        required this.email,
        required this.password,
        required this.type,
    });

}