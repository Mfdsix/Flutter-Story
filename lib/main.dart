import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/data/api/dicoding_story_service.dart';
import 'package:puth_story/data/db/auth_repository.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/routes/route_information_parser.dart';
import 'package:puth_story/routes/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static const appTitle = "Puth Story";

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late MyRouterDelegate myRouterDelegate;
  late MyRouteInformationParser myRouteInformationParser;
  late AuthProvider authProvider;

  @override
  void initState() {
    final authRepository = AuthRepository();
    final apiService = DicodingStoryService();

    authProvider = AuthProvider(authRepository: authRepository, apiService: apiService);
    myRouterDelegate = MyRouterDelegate(authRepository);
    myRouteInformationParser = MyRouteInformationParser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authProvider,
      child: defaultTargetPlatform == TargetPlatform.iOS
        ? iOSScaffold()
          : androidScaffold()
    );
  }

  Widget iOSScaffold(){
    return CupertinoApp.router(
      title: MyApp.appTitle,
      routerDelegate: myRouterDelegate,
      routeInformationParser: myRouteInformationParser,
      backButtonDispatcher: RootBackButtonDispatcher()
    );
  }

  Widget androidScaffold(){
    return MaterialApp.router(
      title: MyApp.appTitle,
      routerDelegate: myRouterDelegate,
      routeInformationParser: myRouteInformationParser,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
