import 'package:flutter/widgets.dart';
import 'package:puth_story/db/auth_repository.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/model/api/register.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<bool> login(LoginRequest reqBody) async {
    isLoadingLogin = true;
    notifyListeners();

    // do login

    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> register(RegisterRequest reqBody) async {
    isLoadingRegister = true;
    notifyListeners();

    // do register

    isLoadingRegister = false;
    notifyListeners();

    return true;
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