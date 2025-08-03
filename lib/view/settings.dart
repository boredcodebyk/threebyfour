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
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text("Theme"),
                  onTap: () => context.push('/settings/theme'),
                ),
              ],
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
                        Divider(height: 4,color: Theme.of(context).scaffoldBackgroundColor,),
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
                        Divider(height: 4,color: Theme.of(context).scaffoldBackgroundColor,),

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
