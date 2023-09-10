class LoginRequest {
  String email;
  String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() =>
      {
        "email": email,
        "password": password
      };
}

class LoginResponse {
  bool? error;
  String? message;
  User? loginResult;

  LoginResponse({this.error, this.message, this.loginResult});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    loginResult =
        json['loginResult'] != null ? User.fromJson(json['loginResult']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (loginResult != null) {
      data['loginResult'] = loginResult!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? name;
  String? token;

  User({this.userId, this.name, this.token});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['token'] = token;
    return data;
  }
}
