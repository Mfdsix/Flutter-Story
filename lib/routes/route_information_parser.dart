import 'package:flutter/cupertino.dart';
import 'package:puth_story/model/page_configuration.dart';

class MyRouteInformationParser extends RouteInformationParser<PageConfiguration>{
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation
      ) async {
    final uri = Uri.parse(routeInformation.location.toString());

    if(uri.pathSegments.isEmpty){
      return PageConfiguration.home();
    }else if(uri.pathSegments.length == 1) {
      final first = uri.pathSegments[0].toLowerCase();

      if(first == 'splash'){
        return PageConfiguration.splash();
      }else if(first == 'home'){
        return PageConfiguration.home();
      }
    }else if(uri.pathSegments.length == 2){
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();

      if(first == 'auth'){
        if(second == 'login'){
          return PageConfiguration.login();
        }else if(second == 'register'){
          return PageConfiguration.register();
        }
      }else if(first == 'story'){
        if(second == 'create'){
          return PageConfiguration.createStory();
        }else{
          return PageConfiguration.detailStory(second);
        }
      }
    }

    return PageConfiguration.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration configuration){
    if(configuration.isUnknownPage){
      return const RouteInformation(location: "/unknown");
    }else if(configuration.isSplashPage) {
      return const RouteInformation(location: "/splash");
    }else if(configuration.isHomePage){
      return const RouteInformation(location: "/home");
    }else if(configuration.isLoginPage){
      return const RouteInformation(location: "/auth/login");
    }else if(configuration.isRegisterPage){
      return const RouteInformation(location: "/auth/register");
    }else if(configuration.isCreateStoryPage){
      return const RouteInformation(location: "/story/create");
    }else if(configuration.isDetailStoryPage){
      return RouteInformation(location: "/auth/${configuration.storyId}");
    }else{
      return null;
    }
  }
}