import 'dart:convert';

GetAllStoryResponse getAllStoryResponseFromJson(String str) => GetAllStoryResponse.fromJson(json.decode(str));

String getAllStoryResponseToJson(GetAllStoryResponse data) => json.encode(data.toJson());

class GetAllStoryResponse {
  bool error;
  String message;
  List<Story> listStory;

  GetAllStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetAllStoryResponse.fromJson(Map<String, dynamic> json) => GetAllStoryResponse(
    error: json["error"],
    message: json["message"],
    listStory: List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
  };
}

class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double lat;
  double lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };
}
