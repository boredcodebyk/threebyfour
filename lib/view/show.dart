import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ShowView extends ConsumerStatefulWidget {
  ShowView({super.key, required this.list, this.initialIndex = 0})
    : pageController = PageController(initialPage: initialIndex);
  final List<FileSystemEntity> list;
  final int initialIndex;
  final PageController pageController;
  @override
  ConsumerState<ShowView> createState() => _ShowViewState();
}

class _ShowViewState extends ConsumerState<ShowView> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoViewGallery.builder(
        itemCount: widget.list.length,
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        scrollPhysics: const BouncingScrollPhysics(),
        loadingBuilder: (context, event) => Image.memory(kTransparentImage),
        builder: (context, index) {
          var item = widget.list[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(item as File),
            filterQuality: FilterQuality.high,
            minScale: PhotoViewComputedScale.contained * (0.4),
            initialScale: PhotoViewComputedScale.contained * (0.8),
          );
        },
      ),
    );
  }
}
