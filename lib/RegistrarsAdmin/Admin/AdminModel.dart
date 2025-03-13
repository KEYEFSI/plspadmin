
class AdminProfileModel {
  final String username;
  final String? fullname;
  final String? usertype;
  final String? profileImage;
  final String? number;
  final String? address;
  final String? gmail;
  final int? window;

  AdminProfileModel({
    required this.username,
    this.fullname,
    this.usertype,
    this.profileImage,
    this.number,
    this.address,
    this.gmail,
    this.window,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      username: json['username'] as String,
      fullname: json['fullname'] as String?,
      usertype: json['usertype'] as String?,
      profileImage: json['profile_image'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      gmail: json['gmail'] as String?,
      window: json['window'] != null ? json['window'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'usertype': usertype,
      'profile_image': profileImage,
      'number': number,
      'address': address,
      'gmail': gmail,
      'window': window,
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
  final String? email;
  final String? number;

  UpdateProfileModel({
    required this.username,
    this.email,
    this.number,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      username: json['username'] as String,
      email: json['email'] as String?,
      number: json['number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      if (email != null) 'email': email,
      if (number != null) 'number': number,
    };
  }
}
