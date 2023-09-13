import 'package:flutter/foundation.dart';
import 'package:puth_story/data/api/dicoding_story_service.dart';
import 'package:puth_story/data/db/auth_repository.dart';
import 'package:puth_story/model/api/get_all_story.dart';
import 'package:puth_story/model/api/detail_story.dart' as detail;
import 'package:puth_story/model/api/post_story.dart';
import 'package:puth_story/utils/result_state.dart';

class StoryProvider extends ChangeNotifier{
  final DicodingStoryService apiService;
  final AuthRepository authRepository;

  StoryProvider({required this.apiService, required this.authRepository}){
    _fetchData();
  }

  ResultState state = ResultState.standBy;
  List<Story> list = [];
  detail.Story? data;
  String? message;

  Future<dynamic> _fetchData() async {
    state = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.getAllStories(token);

    if(response == null){
      state = ResultState.error;
      message = "Failed to load stories";
      return notifyListeners();
    }
    else if(response.isEmpty){
      state = ResultState.noData;
      message = "No stories found";
      return notifyListeners();
    }

    state = ResultState.hasData;
    list = response;

    notifyListeners();
    return list;
  }

  Future<dynamic> fetchDetail(String storyId) async {
    state = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.getStoryById(token, storyId);

    if(response == null){
      state = ResultState.error;
      message = "Story not found";
      return notifyListeners();
    }

    state = ResultState.hasData;
    data = response;

    notifyListeners();
    return data;
  }

  Future<dynamic> postStory(PostStoryFileRequest fileBody, PostStoryBodyRequest body) async {
    state = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.postStory(token, fileBody, body);

    if(response == true){
      state = ResultState.hasData;
      _fetchData();

      return notifyListeners();
    }

    state = ResultState.error;
    message = "Failed to add Story";
    notifyListeners();

    return response;
  }
}