import 'package:flutter/widgets.dart';
import 'package:puth_story/data/api/dicoding_story_service.dart';
import 'package:puth_story/data/db/auth_repository.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/model/api/register.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final DicodingStoryService apiService;

  AuthProvider({required this.authRepository, required this.apiService});

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  String message = "";
  bool isLoggedIn = false;

  Future<bool> login(LoginRequest reqBody) async {
    isLoadingLogin = true;
    notifyListeners();

    final response = await apiService.postLogin(reqBody);
    if(response != null){
      await authRepository.login(response);
    }

    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> register(RegisterRequest reqBody) async {
    isLoadingRegister = true;
    notifyListeners();

    final isRegistered = await apiService.postRegister(reqBody);

    isLoadingRegister = false;
    notifyListeners();

    return isRegistered;
  }

  Future logout() async {
    isLoadingLogout = true;
    notifyListeners();

    await authRepository.logout();
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();
  }
}