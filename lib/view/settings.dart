import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(title: Text("Settings")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.phone_android),
                      title: Text("Theme"),
                      onTap: () => context.push('/settings/theme'),
                    ),
                    Divider(
                      height: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    ListTile(
                      leading: Icon(Icons.folder_outlined),
                      title: Text("Recent Folder"),
                      onTap: () => context.push('/settings/recent'),
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("About"),
                      onTap: () => context.push('/settings/about'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeSettingView extends ConsumerWidget {
  const ThemeSettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(title: Text("Theme")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        RadioListTile(
                          value: ThemeMode.system,
                          groupValue: ref.watch(themeModeProvider),
                          onChanged:
                              (value) => ref
                                  .read(themeModeProvider.notifier)
                                  .update(value!),
                          title: Text("System"),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                        Divider(
                          height: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        RadioListTile(
                          value: ThemeMode.light,
                          groupValue: ref.watch(themeModeProvider),
                          onChanged:
                              (value) => ref
                                  .read(themeModeProvider.notifier)
                                  .update(value!),
                          title: Text("Light"),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                        Divider(
                          height: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),

                        RadioListTile(
                          value: ThemeMode.dark,
                          groupValue: ref.watch(themeModeProvider),
                          onChanged:
                              (value) => ref
                                  .read(themeModeProvider.notifier)
                                  .update(value!),
                          title: Text("Dark"),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentFolderSettingsView extends ConsumerStatefulWidget {
  const RecentFolderSettingsView({super.key});

  @override
  ConsumerState<RecentFolderSettingsView> createState() =>
      _RecentFolderSettingsViewState();
}

class _RecentFolderSettingsViewState
    extends ConsumerState<RecentFolderSettingsView> {
  late List<String> folderList;

  void referesh() {
    folderList = ref.watch(recentFolderProvider);
  }

  Future<void> removeFolder(index) async {
    bool result = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Sure?"),
            content: Text("This process is irreversible."),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
    );
    if (result) {
      String path = folderList.removeAt(index);
      ref.read(recentFolderProvider.notifier).updateList(folderList);
      if (ref.watch(selectedDirProvider) == path) {
        ref.read(selectedDirProvider.notifier).update("");
      }
      referesh();
    }
  }

  @override
  Widget build(BuildContext context) {
    referesh();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: Text("Recent Folder")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  folderList.isNotEmpty
                      ? Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var item = folderList[index];
                            return ListTile(
                              title: Text(item),
                              trailing: IconButton(
                                onPressed: () => removeFolder(index),
                                icon: Icon(Icons.close),
                              ),
                            );
                          },
                          separatorBuilder:
                              (context, index) => Divider(height: 4),
                          itemCount: folderList.length,
                        ),
                      )
                      : Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Opacity(
                            opacity: 0.2,
                            child: Text(
                              "Empty",
                              style: TextStyle(
                                fontFamily: "Staatliches",
                                fontSize: 96,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
