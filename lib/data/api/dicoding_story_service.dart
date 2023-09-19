import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:puth_story/model/api/detail_story.dart' as detail;
import 'package:puth_story/model/api/general.dart';
import 'package:puth_story/model/api/get_all_story.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/model/api/post_story.dart';
import 'package:puth_story/model/api/register.dart';
import 'package:http/http.dart' as http;

class DicodingStoryService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<bool> postRegister(RegisterRequest body) async {
    final result =
        await http.post(Uri.parse("$_baseUrl/register"), body: body.toJson());

    print(result.statusCode);
    print(json.decode(result.body));

    if (result.statusCode == 201) {
      final response = GeneralResponse.fromJson(json.decode(result.body));
      print(response.toString());

      return !response.error;
    }

    return false;
  }

  Future<User?> postLogin(LoginRequest body) async {
    final result = await http.post(Uri.parse("$_baseUrl/login"), body: body.toJson());

    if (result.statusCode == 200) {
      final response = LoginResponse.fromJson(json.decode(result.body));

      return response.loginResult;
    }

    return null;
  }

  Future<List<Story>?> getAllStories(String? token, Map<String, dynamic>? parameters) async {
    final result = await http.get(Uri.parse("$_baseUrl/stories").replace(queryParameters: parameters),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (result.statusCode == 200) {
      final response = GetAllStoryResponse.fromJson(json.decode(result.body));

      return response.listStory;
    }

    return null;
  }

  Future<bool> postStory(String? token, PostStoryFileRequest fileBody,
      PostStoryBodyRequest body) async {
    final uri = Uri.parse("$_baseUrl/stories");
    final request = http.MultipartRequest('POST', uri);

    final file = http.MultipartFile.fromBytes("photo", fileBody.fileBytes,
        filename: fileBody.filename);
    final Map<String, String> fields = {
      "description": body.description,
    };

    if(body.lat != null){
      fields['lat'] = body.lat.toString();
    }
    if(body.lon != null){
      fields['lon'] = body.lon.toString();
    }

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    };

    request.files.add(file);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse result = await request.send();

    if (result.statusCode == 201) {
      final Uint8List responseList = await result.stream.toBytes();
      final String responseString = String.fromCharCodes(responseList);
      final response = GeneralResponse.fromJson(json.decode(responseString));

      return !response.error;
    }

    return false;
  }

  Future<detail.Story?> getStoryById(String? token, String storyId) async {
    final result = await http.get(Uri.parse("$_baseUrl/stories/$storyId"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (result.statusCode == 200) {
      final response =
          detail.DetailStoryResponse.fromJson(json.decode(result.body));

      return response.story;
    }

    return null;
  }
}
