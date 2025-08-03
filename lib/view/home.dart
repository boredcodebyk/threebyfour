import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/filled_button_large.dart';
import '../model/settings.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Future<bool> openFolderSelector(context) async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (status.isRestricted) {
        status = await Permission.manageExternalStorage.request();
      }

      if (status.isDenied) {
        status = await Permission.manageExternalStorage.request();
      }
      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Please add permission for app to manage external storage',
            ),
          ),
        );
      }
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
      return false;
    } else {
      ref.read(selectedDirProvider.notifier).update(selectedDirectory);
      ref.read(recentFolderProvider.notifier).update(selectedDirectory);
      return true;
    }
  }

  String getFolderName(String path) {
    return path.split(RegExp(r'\\|\/')).last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "3/4",
                style: TextStyle(
                  fontFamily: "Staatliches",
                  fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                ),
              ),
              FilledButtonLarge(
                label: "Select Folder",
                onPressed: () async {
                  final result = await openFolderSelector(context);
                  if (result) {
                    if (!mounted) return;
                    context.push('/gallery');
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: [
                    if (ref.watch(selectedDirProvider).isNotEmpty)
                      ActionChip(
                        avatar: Icon(Icons.autorenew),
                        label: Text("Continue from last session?"),
                        onPressed: () => context.push('/gallery'),
                      ),
                    ActionChip(
                      avatar: Icon(Icons.settings_outlined),
                      label: Text("Settings"),
                      onPressed: () => context.push('/settings'),
                    ),
                    ...ref.watch(recentFolderProvider).map((e) {
                      return ActionChip(
                        avatar: Icon(Icons.folder),
                        label: Text(getFolderName(e)),
        
                        onPressed: () {
                          ref.read(selectedDirProvider.notifier).update(e);
                          context.push('/gallery');
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
