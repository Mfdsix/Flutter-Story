import 'package:flutter/widgets.dart';
import 'package:puth_story/data/api/dicoding_story_service.dart';
import 'package:puth_story/data/db/auth_repository.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/model/api/register.dart';
import 'package:puth_story/utils/result_state.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final DicodingStoryService apiService;

  AuthProvider({required this.authRepository, required this.apiService}){
    _getUser();
  }

  ResultState state = ResultState.standBy;
  String? message;
  bool isLoggedIn = false;
  User? user;

  Future<bool> login(LoginRequest reqBody) async {
    state = ResultState.loading;
    notifyListeners();

    final response = await apiService.postLogin(reqBody);
    if(response != null){
      await authRepository.login(response);
    }

    isLoggedIn = await authRepository.isLoggedIn();

    if(isLoggedIn){
      state = ResultState.hasData;
      notifyListeners();

      return true;
    }

    state = ResultState.error;
    message = "Wrong username or password";
    notifyListeners();

    return false;
  }

  Future _getUser() async {
    final response = await authRepository.getUser();
    user = response;
    notifyListeners();
  }

  Future<bool> register(RegisterRequest reqBody) async {
    state = ResultState.loading;
    notifyListeners();

    final isRegistered = await apiService.postRegister(reqBody);

    if(isRegistered){
      state = ResultState.hasData;
      notifyListeners();

      return true;
    }

    state = ResultState.error;
    message = "Failed to register";
    notifyListeners();

    return false;
  }

  Future logout() async {
    state = ResultState.loading;
    notifyListeners();

    await authRepository.logout();
    isLoggedIn = await authRepository.isLoggedIn();

    state = ResultState.hasData;
    notifyListeners();
  }
}