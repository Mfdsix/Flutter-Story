import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puth_story/data/db/auth_repository.dart';
import 'package:puth_story/model/page_configuration.dart';
import 'package:puth_story/screen/auth/login.dart';
import 'package:puth_story/screen/auth/register.dart';
import 'package:puth_story/screen/camera.dart';
import 'package:puth_story/screen/home.dart';
import 'package:puth_story/screen/splash.dart';
import 'package:puth_story/screen/story/add.dart';
import 'package:puth_story/screen/story/detail.dart';
import 'package:puth_story/screen/unknown.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  bool? isUnknown;
  bool isCamera = false;
  String? selectedStoryId;
  String? alertMessage;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isCreateStory = false;
  List<CameraDescription> listCamera = [];

  List<Page> get _unknownStack => [
        _platformPage("unknownPage", UnknownPage(
          onBack: () {
            isUnknown = false;
          },
        ))
      ];
  List<Page> get _splashStack =>
      [_platformPage("splashPage", const SplashPage())];
  List<Page> get _loggedOutStack => [
        _platformPage(
            "loginPage",
            LoginPage(onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            }, onRegister: () {
              isRegister = true;
              notifyListeners();
            }, onError: (String message) {
              alertMessage = message;
              notifyListeners();
            })),
        if (isRegister == true)
          _platformPage(
              "registerPage",
              RegisterPage(onRegister: () {
                isRegister = false;
                notifyListeners();
              }, onLogin: () {
                isRegister = false;
                notifyListeners();
              }, onError: (String message) {
                alertMessage = message;
                notifyListeners();
              })),
//               still working on it
//         if (alertMessage != null) PlatformAlert(message: alertMessage!),
      ];
  List<Page> get _loggedInStack => [
        _platformPage(
            "homePage",
            HomePage(
              onClickItem: (String storyId) {
                selectedStoryId = storyId;
                notifyListeners();
              },
              onCreate: () {
                isCreateStory = true;
                notifyListeners();
              },
              onLogout: () {
                isLoggedIn = false;
                notifyListeners();
              },
            )),
        if (isCamera == true)
          _platformPage("cameraPage", CameraPage(
              cameras: listCamera,
              onSend: () {
            isCamera = false;
            notifyListeners();
          })),
        if (isCreateStory == true)
          _platformPage(
              "createStoryPage",
              StoryAddPage(
                onOpenCamera: (List<CameraDescription> cameras) {
                  isCamera = true;
                  listCamera = cameras;
                  notifyListeners();
                },
                onUploaded: () {
                  isCreateStory = false;
                  notifyListeners();
                },
              )),
        if (isCreateStory == false && selectedStoryId != null)
          _platformPage(
            "detailStoryPage",
            DetailStoryPage(
              storyId: selectedStoryId!,
            ),
          )
      ];

  @override
  Widget build(BuildContext context) {
    if (isUnknown == true) {
      historyStack = _unknownStack;
    } else if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);

        if (!didPop) return false;

        isRegister = false;
        selectedStoryId = null;
        isCamera = false;
        isCreateStory = false;

        notifyListeners();

        return true;
      },
    );
  }

  @override
  get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (isLoggedIn == true && selectedStoryId == null && isCreateStory == false) {
      return PageConfiguration.home();
    } else if (selectedStoryId == null && isCreateStory == true) {
      return PageConfiguration.createStory();
    } else if (selectedStoryId != null) {
      return PageConfiguration.detailStory(selectedStoryId!);
    } else if(isCamera == true){
      return PageConfiguration.openCamera();
    } else {
      return null;
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      isUnknown = false;
      selectedStoryId = null;
      isRegister = false;
    } else if (configuration.isCreateStoryPage) {
      selectedStoryId = null;
      isCreateStory = true;
    } else if (configuration.isDetailStoryPage) {
      selectedStoryId = configuration.storyId.toString();
    }else if (configuration.isCameraPage){
      isCamera = true;
    } else {
      print("New route is invalid");
    }

    notifyListeners();
  }

  Page<dynamic> _platformPage(String routeKey, Widget child) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoPage(
          key: ValueKey(routeKey),
          child: child,
        );
      default:
        return MaterialPage(
          key: ValueKey(routeKey),
          child: child,
        );
    }
  }
}
