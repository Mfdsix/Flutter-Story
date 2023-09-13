import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/get_all_story.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class HomePage extends StatefulWidget {
  final Function(String) onClickItem;
  final Function() onCreate;
  final Function() onLogout;

  const HomePage(
      {super.key,
      required this.onClickItem,
      required this.onCreate,
      required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return PlatformScaffold(
        title: "Puth Story",
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(
                  onPressed: widget.onCreate,
                  child: const Text("Create Story")),
              OutlinedButton(
                  onPressed: () async {
                    await authProvider.logout();
                    widget.onLogout();
                  },
                  child: const Text("Logout")),
            ]),
            const VMargin(
              height: 16.0,
            ),
            _storyListener()
          ],
        ));
  }

  Widget _storyListener() {
    return Consumer<StoryProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.hasData:
            return Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.list.length,
                itemBuilder: (context, index) {
                  return _storyItem(context, provider.list[index]);
                },
              ),
            );
          case ResultState.noData:
            return const Center(
              child: Text("No Story"),
            );
          case ResultState.error:
            return Center(
              child: Text(provider.message ?? "Failed to load Story"),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _storyItem(BuildContext context, Story story) {
    return InkWell(
      key: ValueKey(story.id),
      onTap: () => widget.onClickItem(story.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              fit: BoxFit.fill,
              child: CachedNetworkImage(
                imageUrl: story.photoUrl,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 64,
                ),
              ),
            ),
          ),
          const VMargin(),
          Text(story.name, style: Theme.of(context).textTheme.labelLarge),
          Text(story.description,
              style: Theme.of(context).textTheme.labelMedium),
          const VMargin(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
