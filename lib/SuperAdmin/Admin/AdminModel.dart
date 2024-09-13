

class AdminAccount {
  String? fullname;
  String? firstName;
  String? middleName;
  String? lastName;
  String? username;
  String? password;
  String? usertype;
  String? profileImage;
  String? address;
  String? number;

  AdminAccount({
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.password,
    this.usertype,
    this.profileImage,
    this.address,
    this.number,
  });

  // Deserialize from JSON
  factory AdminAccount.fromJson(Map<String, dynamic> json) {
    return AdminAccount(
      fullname: json['fullname'],
      firstName: json['First_Name'],
      middleName: json['Middle_Name'],
      lastName: json['Last_Name'],
      username: json['username'],
      password: json['password'],
      usertype: json['usertype'],
      profileImage: json['profile_image'],
      address: json['address'],
      number: json['number'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'username': username,
      'password': password,
      'usertype': usertype,
      'profile_image': profileImage,
      'address': address,
      'number': number,
    };
  }
}


class FinanceAdmin {
  final String? username;
  final String? fullname;
  final String? usertype;
  final String? profileImage;
  final String? address;
  final String? number;

  FinanceAdmin({
    this.username,
    this.fullname,
    this.usertype,
    this.profileImage,
    this.address,
    this.number,
  });

  factory FinanceAdmin.fromJson(Map<String, dynamic> json) {
    return FinanceAdmin(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      usertype: json['usertype'] as String?,
      profileImage: json['profile_image'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profileImage,
      'address': address,
      'number': number,
    };
  }
}

class RegistrarAdmin {
  final String? username;
  final String? fullname;
  final String? usertype;
  final String? profileImage;
  final String? address;
  final String? number;

  RegistrarAdmin({
    this.username,
    this.fullname,
    this.usertype,
    this.profileImage,
    this.address,
    this.number,
  });

  factory RegistrarAdmin.fromJson(Map<String, dynamic> json) {
    return RegistrarAdmin(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      usertype: json['usertype'] as String?,
      profileImage: json['profile_image'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profileImage,
      'address': address,
      'number': number,
    };
  }
}