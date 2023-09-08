import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/detail_story.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';

class DetailStoryPage extends StatelessWidget {

  final String storyId;

  const DetailStoryPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    storyProvider.fetchDetail(user?.token ?? "-", storyId);

    return PlatformScaffold(
        title: "Puth Story", child: _storyListener(context, storyProvider),);
  }

  Widget _storyListener(BuildContext context, StoryProvider provider){
    switch(provider.state){
      case ResultState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ResultState.error:
        return const Center(
          child: Text("Failed to load story"),
        );
      default:
        return _storyDetail(context, provider.data!);
    }
  }

  Widget _storyDetail(BuildContext context, Story story){
    return Column(children: [
      Hero(
      tag: story.id,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.network(story.photoUrl),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(story.name, style: Theme.of(context).textTheme.labelLarge),
          Text(story.description, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    ),
    ],
    );
  }
}
