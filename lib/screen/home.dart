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

  const HomePage({super.key, required this.onClickItem, required this.onCreate, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final storyProvider = Provider.of<StoryProvider>(context, listen: true);
    storyProvider.fetchData(user?.token ?? "-");

    return PlatformScaffold(
        title: "Puth Story", child:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: widget.onCreate, child: const Text("Create Story")),
                OutlinedButton(onPressed: () async {
                  await authProvider.logout();
                  widget.onLogout();
                }, child: const Text("Logout")),
              ]
            ),
            const VMargin(
              height: 16.0,
            ),
            _storyListener(storyProvider)
          ],
        )
    );
  }

  Widget _storyListener(StoryProvider provider) {
    switch (provider.state) {
      case ResultState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ResultState.noData:
        return const Center(
          child: Text("No Story"),
        );
      default:
        return ListView.builder(
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            return _storyItem(context, provider.list[index]);
          },
        );
    }
  }

  Widget _storyItem(BuildContext context, Story story) {
    return InkWell(
      key: ValueKey(story.id),
      onTap: widget.onClickItem(story.id),
      child: Column(children: [
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
        const VMargin(),
        Text(story.name, style: Theme.of(context).textTheme.labelLarge),
        Text(story.description, style: Theme.of(context).textTheme.labelMedium),
      ],
      ),
    );
  }
}
