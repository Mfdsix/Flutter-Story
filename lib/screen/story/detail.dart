import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/detail_story.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';

class DetailStoryPage extends StatefulWidget {
  final String storyId;

  const DetailStoryPage({super.key, required this.storyId});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {

  @override
  void initState() {
    Future.microtask(() => context.read<StoryProvider>().fetchDetail(widget.storyId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    storyProvider.fetchDetail(widget.storyId);

    return PlatformScaffold(
      title: "Puth Story",
      child: SingleChildScrollView(
        child: _storyListener(context)
      ),
    );
  }

  Widget _storyListener(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, _) {
      switch (provider.getByIdState) {
        case ResultState.hasData:
          return _storyDetail(context, provider.data!);
        case ResultState.error:
          return const Center(
            child: Text("Failed to load story"),
          );
        default:
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    });
  }

  Widget _storyDetail(BuildContext context, Story story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.name, style: Theme.of(context).textTheme.labelLarge),
              Text(story.description,
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ],
    );
  }
}
