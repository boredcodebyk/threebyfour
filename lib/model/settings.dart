import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences.dart';

final selectedDirProvider = NotifierProvider<SelectedDirNotifier, String>(
  SelectedDirNotifier.new,
);

class SelectedDirNotifier extends Notifier<String> {
  @override
  String build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getString('selectedDir') ?? "";
    listenSelf((prev, next) {
      preferences.setString('selectedDir', next);
    });
    return currentValue;
  }

  void update(path) => state = path;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = ThemeMode.values.firstWhere(
      (test) => test.toString() == preferences.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    listenSelf((prev, next) {
      preferences.setString('themeMode', next.toString());
    });
    return currentValue;
  }

  void update(ThemeMode themeMode) => state = themeMode;
}

final recentFolderProvider =
    NotifierProvider<RecentFolderNotifier, List<String>>(
      RecentFolderNotifier.new,
    );

class RecentFolderNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getStringList('recentFolder') ?? [];
    listenSelf((prev, next) {
      preferences.setStringList('recentFolder', next);
    });
    return currentValue;
  }

  void update(path) {
    if (!state.contains(path)) {
      state = [path, ...state];
    }
  }
}
