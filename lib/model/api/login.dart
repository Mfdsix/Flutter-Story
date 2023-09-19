import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginRequest {
  String email;
  String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  bool? error;
  String? message;
  User? loginResult;

  LoginResponse({this.error, this.message, this.loginResult});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class User {
  String? userId;
  String? name;
  String? token;

  User({this.userId, this.name, this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
