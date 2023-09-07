import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
  bool error;
  String message;

  GeneralResponse({
    required this.error,
    required this.message,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}