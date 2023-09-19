import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@JsonSerializable()
class RegisterRequest {
  String name;
  String email;
  String password;

  RegisterRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}