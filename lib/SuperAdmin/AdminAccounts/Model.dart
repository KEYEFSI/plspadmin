

class AdminModel {
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? usertype;
  final String? profileImage;
  final String? address;
  final String? number;
  final String? gmail;

  AdminModel({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.usertype,
    this.profileImage,
    this.address,
    this.number,
    this.gmail,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      fullname: json['fullname'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      usertype: json['usertype'],
      profileImage: json['profileImage'],
      address: json['address'],
      number: json['number'],
      gmail: json['gmail'],
    );
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

class WindowData {
  final String windowName;
  final List<String> programs;

  WindowData({required this.windowName, required this.programs});

  factory WindowData.fromJson(Map<String, dynamic> json) {
    return WindowData(
      // Convert windowName to String in case it's an int
      windowName: json['windowName'].toString(),
      programs: List<String>.from(json['programs'] ?? []),
    );
  }
}


class CreateFinanceAdminModel {
  final String username;
  final String password;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;

  CreateFinanceAdminModel({
    required this.username,
    required this.password,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
  });

  // Convert the model to a map (for API request)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
    };
  }

  // Factory method to create the model from JSON response
  factory CreateFinanceAdminModel.fromJson(Map<String, dynamic> json) {
    return CreateFinanceAdminModel(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}


class DeleteAdminModel {
  final String username;
  final String fullname;

  DeleteAdminModel({required this.username, required this.fullname});

  factory DeleteAdminModel.fromJson(Map<String, dynamic> json) {
    return DeleteAdminModel(
      username: json['username'],
      fullname: json['fullname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
    };
  }
}
