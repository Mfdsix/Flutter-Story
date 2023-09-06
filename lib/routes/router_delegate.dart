import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puth_story/db/auth_repository.dart';
import 'package:puth_story/model/page_configuration.dart';
import 'package:puth_story/screen/home.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin{
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  bool? isUnknown;
  String? selectedStoryId;

  MyRouterDelegate(this.authRepository): _navigatorKey = GlobalKey<NavigatorState>(){
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

  List<Page> get _unknownStack => [];
  List<Page> get _splashStack => [];
  List<Page> get _loggedOutStack => [];
  List<Page> get _loggedInStack => [
    _platformPage("homePage", const HomePage()),
  ];

  @override
  Widget build(BuildContext context){

    if(isUnknown == true){
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
      pages: [
        _platformPage("homePage", const HomePage())
      ]
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
    } else if (selectedStoryId == null && isCreateStory == false) {
      return PageConfiguration.home();
    } else if (selectedStoryId == null && isCreateStory == true) {
      return PageConfiguration.createStory();
    } else if (selectedStoryId != null) {
      return PageConfiguration.detailStory(selectedStoryId!);
    } else {
      return null;
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if(configuration.isUnknownPage){
      isUnknown = true;
      isRegister = false;
    }else if(configuration.isRegisterPage){
      isRegister = true;
    }else if(configuration.isHomePage || configuration.isLoginPage || configuration.isSplashPage){
      isUnknown = false;
      selectedStoryId = null;
      isRegister = false;
    }else if(configuration.isCreateStoryPage){
      selectedStoryId = null;
      isCreateStory = true;
    }else if(configuration.isDetailStoryPage){
      selectedStoryId = configuration.storyId.toString();
    }else{
      print("New route is invalid");
    }

    notifyListeners();
  }

  Page<dynamic> _platformPage(String routeKey, Widget child){
    switch(defaultTargetPlatform){
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