import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ShowView extends ConsumerStatefulWidget {
  const ShowView({super.key, required this.list});
  final List<FileSystemEntity> list;
  @override
  ConsumerState<ShowView> createState() => _ShowViewState();
}

class _ShowViewState extends ConsumerState<ShowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoViewGallery.builder(
        itemCount: widget.list.length,
        scrollPhysics: const BouncingScrollPhysics(),
        loadingBuilder: (context, event) => Image.memory(kTransparentImage),
        builder: (context, index) {
          var item = widget.list[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(item as File),
            filterQuality: FilterQuality.high,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            initialScale: PhotoViewComputedScale.contained,
          );
        },
      ),
    );
  }
}
