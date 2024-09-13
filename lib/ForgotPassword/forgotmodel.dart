class ForgotPasswordModel {
  final String message;
  final String? error;

  ForgotPasswordModel({required this.message, this.error});

  // Factory method to create an instance from a JSON response
  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      message: json['message'],
      error: json['error'],
    );
  }
}

class VerifyTokenResponse {
  final String? message;
  final String? email;
  final String? token;
  final String? error;

  VerifyTokenResponse({this.message, this.email, this.token, this.error});

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTokenResponse(
      message: json['message'],
      email: json['email'],
      token: json['token'],
      error: json['error'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
      'token': token,
      'error': error,
    };
  }
}


class UpdatePasswordResponse {
  final String? message;
  final String? error;

  UpdatePasswordResponse({this.message, this.error});

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
    };
  }
}
