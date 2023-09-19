import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'detail_story.g.dart';

DetailStoryResponse detailStoryResponseFromJson(String str) => DetailStoryResponse.fromJson(json.decode(str));

String detailStoryResponseToJson(DetailStoryResponse data) => json.encode(data.toJson());

@JsonSerializable()
class DetailStoryResponse {
  bool error;
  String message;
  Story story;

  DetailStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) => _$DetailStoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DetailStoryResponseToJson(this);
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
