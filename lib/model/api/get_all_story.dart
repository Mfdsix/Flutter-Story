import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_story.g.dart';

GetAllStoryResponse getAllStoryResponseFromJson(String str) => GetAllStoryResponse.fromJson(json.decode(str));

String getAllStoryResponseToJson(GetAllStoryResponse data) => json.encode(data.toJson());

@JsonSerializable()
class GetAllStoryResponse {
  bool error;
  String message;
  List<Story> listStory;

  GetAllStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetAllStoryResponse.fromJson(Map<String, dynamic> json) => _$GetAllStoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllStoryResponseToJson(this);
}

@JsonSerializable()
class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
