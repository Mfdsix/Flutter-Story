class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool createStory;
  final bool? loggedIn;
  final String? storyId;
  final bool? isCamera;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        createStory = false,
        storyId = null,
  isCamera = false;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        createStory = false,
        storyId = null,
        isCamera = false;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = false,
        createStory = false,
        storyId = null,
        isCamera = false;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        createStory = false,
        storyId = null,
        isCamera = false;

  PageConfiguration.createStory()
      : unknown = false,
        register = false,
        loggedIn = true,
        createStory = true,
        storyId = null,
        isCamera = false;

  PageConfiguration.detailStory(String id)
      : unknown = false,
        register = false,
        loggedIn = true,
        createStory = false,
        storyId = id,
        isCamera = false;

  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        createStory = false,
        storyId = null,
        isCamera = false;

  PageConfiguration.openCamera()
      : unknown = false,
        register = false,
        loggedIn = true,
        createStory = false,
        storyId = null,
        isCamera = true;

  bool get isSplashPage => unknown == false && loggedIn == null;
  bool get isLoginPage => unknown == false && loggedIn == false && register == true;
  bool get isRegisterPage => unknown == false && loggedIn == false && register == false;
  bool get isHomePage => unknown == false && loggedIn == true && storyId == null && createStory == false;
  bool get isCreateStoryPage => unknown == false && loggedIn == true && storyId == null && createStory == true;
  bool get isDetailStoryPage => unknown == false && loggedIn == true && storyId != null;
  bool get isUnknownPage => unknown == true;
  bool get isCameraPage => isCamera == true;
}
