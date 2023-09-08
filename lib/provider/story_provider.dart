import 'package:flutter/foundation.dart';
import 'package:puth_story/data/api/dicoding_story_service.dart';
import 'package:puth_story/model/api/get_all_story.dart';
import 'package:puth_story/model/api/detail_story.dart' as detail;
import 'package:puth_story/utils/result_state.dart';

class StoryProvider extends ChangeNotifier{
  final DicodingStoryService apiService;

  StoryProvider({required this.apiService});

  ResultState state = ResultState.standBy;
  List<Story> list = [];
  detail.Story? data;

  Future<dynamic> fetchData(String token) async {
    state = ResultState.loading;
    notifyListeners();

    final response = await apiService.getAllStories(token);

    if(response == null){
      state = ResultState.error;
    }
    else if(response.isEmpty){
      state = ResultState.noData;
    }
    else {
      state = ResultState.hasData;
      list = response;
    }

    notifyListeners();
  }

  Future<dynamic> fetchDetail(String token, String storyId) async {
    state = ResultState.loading;
    notifyListeners();

    final response = await apiService.getStoryById(token, storyId);

    if(response == null){
      state = ResultState.error;
    }else{
      state = ResultState.hasData;
      data = response;
    }

    notifyListeners();
  }
}