class AdminFinanceProfile {
  final String username;
  final String fullname;
  final String usertype;
  final String profileImage;
  final String number;
  final String address;

  AdminFinanceProfile({
    required this.username,
    required this.fullname,
    required this.usertype,
    required this.profileImage,
    required this.number,
    required this.address,
  });

  factory AdminFinanceProfile.fromJson(Map<String, dynamic> json) {
    print('JSON received: $json'); // Debug print
    return AdminFinanceProfile(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      usertype: json['usertype'] ?? '',
      profileImage: json['profile_image'] ?? '',
      number: json['number'] ?? '',
      address: json['address'] ?? '',
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
    };
  }
}
