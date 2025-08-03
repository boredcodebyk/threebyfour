import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

import '../component/FilledButtonLarge.dart';

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
  late PageController pageController = widget.pageController;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void next() {
    pageController.nextPage(duration: Duration(milliseconds: 350), curve: Cubic(0.42, 1.67, 0.21, 0.90));
  }

  void previous() {
    pageController.previousPage(duration: Duration(milliseconds: 350), curve: Cubic(0.42, 1.67, 0.21, 0.90));

  }

  bool controllerVisibile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        title: Text('50:00'),
        centerTitle: true,
        actions: [
          if (!controllerVisibile)
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed:
                  () =>
                      setState(() => controllerVisibile = !controllerVisibile),
            ),
        ],
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.list.length,
            pageController: pageController,
            onPageChanged: onPageChanged,
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
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

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controllerVisibile)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Card(
                          elevation: 6,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(99)),
                          ),
                          child: SizedBox(
                            height: 64,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                spacing: 4,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_left),
                                    onPressed: currentIndex == 0 ? null : () => previous(),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.visibility_off),
                                    onPressed:
                                        () => setState(
                                          () =>
                                              controllerVisibile =
                                                  !controllerVisibile,
                                        ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_right),
                                    onPressed: currentIndex +1 == widget.list.length ? null : () => next(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Card(
                        elevation: 6,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                        ),
                        child: SizedBox(
                          height: 64,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              spacing: 4,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),

                                  child: Text(
                                    '${currentIndex + 1}/${widget.list.length}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
