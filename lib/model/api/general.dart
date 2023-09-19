import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'general.g.dart';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

@JsonSerializable()
class GeneralResponse {
  bool error;
  String message;

  GeneralResponse({
    required this.error,
    required this.message,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) => _$GeneralResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}
