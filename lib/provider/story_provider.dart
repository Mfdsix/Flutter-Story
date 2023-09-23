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
  int? page = 1;
  int pageSize = 10;

  detail.Story? data;
  String? message;

  Future<dynamic> fetchData() async {
    if(page == 1){
      getAllState = ResultState.loading;
      notifyListeners();
    }

    Map<String, String> params = {};
    if(page != null) params['page'] = page.toString();
    params['limit'] = pageSize.toString();

    final token = await authRepository.getUserToken();
    final response = await apiService.getAllStories(token, params);

    if(response == null){
      getAllState = ResultState.error;
      message = "Failed to load stories";
    } else if(response.isEmpty){
      if(page == 1){
        getAllState = ResultState.noData;
        message = "No stories found";
      }
      page = null;
    } else if(response.isNotEmpty) {
      getAllState = ResultState.hasData;
      if(page == 1){
        list = response;
      }else{
        list = list + response;
      }

      if(response.length < pageSize){
        page = null;
      }else{
        page = page! + 1;
      }
    }

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
      page = 1;
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