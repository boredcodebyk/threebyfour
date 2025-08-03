import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ShowView extends ConsumerStatefulWidget {
  ShowView({
    super.key,
    required this.list,
    this.initialIndex = 0,
    this.timed = false,
    this.duration = const Duration(milliseconds: 0),
  }) : pageController = PageController(initialPage: initialIndex);
  final bool timed;
  final Duration duration;
  final List<FileSystemEntity> list;
  final int initialIndex;
  final PageController pageController;
  @override
  ConsumerState<ShowView> createState() => _ShowViewState();
}

class _ShowViewState extends ConsumerState<ShowView> {
  late int currentIndex = widget.initialIndex;
  late PageController pageController = widget.pageController;
  late bool timed = widget.timed;
  late Duration duration = widget.duration;
  late ValueNotifier<Duration> durationNotifier = ValueNotifier(duration);

  PausableTimer? timer;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void next() {
    pageController.nextPage(
      duration: Duration(milliseconds: 350),
      curve: Cubic(0.42, 1.67, 0.21, 0.90),
    );
    if (timed) {
      timer?.cancel();
      if (currentIndex + 1 == widget.list.length) {
        showEndAlert();
      } else {
        durationNotifier.value = duration;
        startTimer();
      }
    }
  }

  void previous() {
    pageController.previousPage(
      duration: Duration(milliseconds: 350),
      curve: Cubic(0.42, 1.67, 0.21, 0.90),
    );
    if (timed) {
      timer?.cancel();
      durationNotifier.value = duration;
      startTimer();
    }
  }

  void startTimer() {
    timer = PausableTimer.periodic(Duration(seconds: 1), () => countdown());
    timer!.start();
  }

  void countdown() {
    final sec = durationNotifier.value.inSeconds - 1;
    if (sec == -1) {
      timer?.cancel();
      if (currentIndex + 1 == widget.list.length) {
        showEndAlert();
      } else {
        next();
        durationNotifier.value = duration;
        startTimer();
      }
    } else {
      durationNotifier.value = Duration(seconds: sec);
    }
  }

  void showEndAlert() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Continue?"),
            content: Text(
              "You have completed your timed session. Do you want to continue your session without timer or exit?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: Text("Exit"),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                  setState(() => timed = false);
                },
                child: Text("Continue"),
              ),
            ],
          ),
    );
  }

  String printDuration() {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(durationNotifier.value.inHours);
    final minutes = twoDigit(
      durationNotifier.value.inMinutes.remainder(60).abs(),
    );
    final seconds = twoDigit(
      durationNotifier.value.inSeconds.remainder(60).abs(),
    );
    return durationNotifier.value.inHours > 0
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    if (timed) {
      startTimer();
    }
  }

  @override
  void dispose() {
    if (timed) {
      timer?.cancel();
      durationNotifier.dispose();
    }
    super.dispose();
  }

  bool controllerVisibile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        title:
            timed
                ? StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1)),
                  builder: (context, snapshot) => Text(printDuration()),
                )
                : null,
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
          CallbackShortcuts(
            bindings: {
              SingleActivator(LogicalKeyboardKey.arrowLeft): () {
                previous();
              },
              SingleActivator(LogicalKeyboardKey.arrowRight): () {
                next();
              },
              SingleActivator(LogicalKeyboardKey.escape): () {
                context.pop();
              },
            },
            child: Focus(
              autofocus: true,
              child: PhotoViewGallery.builder(
                itemCount: widget.list.length,
                pageController: pageController,
                onPageChanged: onPageChanged,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                loadingBuilder:
                    (context, event) => Image.memory(kTransparentImage),
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
            ),
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
                                    onPressed:
                                        currentIndex == 0
                                            ? null
                                            : () => previous(),
                                  ),
                                  if (timed)
                                    IconButton(
                                      icon:
                                          timer!.isActive
                                              ? Icon(Icons.pause)
                                              : Icon(Icons.play_arrow),
                                      onPressed: () {
                                        timer!.isActive
                                            ? timer?.pause()
                                            : timer?.start();
                                      },
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
                                    onPressed:
                                        currentIndex + 1 == widget.list.length
                                            ? null
                                            : () => next(),
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
