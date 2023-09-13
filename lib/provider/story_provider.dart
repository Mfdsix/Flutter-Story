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

  StoryProvider({required this.apiService, required this.authRepository});

  ResultState getAllState = ResultState.standBy;
  ResultState getByIdState = ResultState.standBy;
  ResultState postState = ResultState.standBy;

  List<Story> list = [];
  detail.Story? data;
  String? message;

  Future<dynamic> fetchData() async {
    getAllState = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.getAllStories(token);

    if(response == null){
      getAllState = ResultState.error;
      message = "Failed to load stories";
      return notifyListeners();
    }
    else if(response.isEmpty){
      getAllState = ResultState.noData;
      message = "No stories found";
      return notifyListeners();
    }

    getAllState = ResultState.hasData;
    list = response;

    notifyListeners();
    return list;
  }

  Future<dynamic> fetchDetail(String storyId) async {
    getByIdState = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.getStoryById(token, storyId);

    if(response == null){
      getByIdState = ResultState.error;
      message = "Story not found";
      return notifyListeners();
    }

    getByIdState = ResultState.hasData;
    data = response;

    notifyListeners();
    return data;
  }

  Future<dynamic> postStory(PostStoryFileRequest fileBody, PostStoryBodyRequest body) async {
    postState = ResultState.loading;
    notifyListeners();

    final token = await authRepository.getUserToken();
    final response = await apiService.postStory(token, fileBody, body);

    if(response == true){
      postState = ResultState.hasData;
      notifyListeners();
      fetchData();

      return true;
    }

    postState = ResultState.error;
    message = "Failed to add Story";
    notifyListeners();

    return response;
  }
}