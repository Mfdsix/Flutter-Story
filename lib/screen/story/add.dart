import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';

class StoryAddPage extends StatefulWidget {
  const StoryAddPage({super.key});

  @override
  State<StoryAddPage> createState() => _StoryAddPageState();
}

class _StoryAddPageState extends State<StoryAddPage>{

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);

    return PlatformScaffold(title: "Create Story", child: Container());
  }

}
