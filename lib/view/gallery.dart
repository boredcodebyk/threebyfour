import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:transparent_image/transparent_image.dart';

import '../component/FilledButtonLarge.dart';
import '../model/settings.dart';
import 'show.dart';

class GalleryView extends ConsumerStatefulWidget {
  const GalleryView({super.key});

  @override
  ConsumerState<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView>
    with AutomaticKeepAliveClientMixin {
  late List<FileSystemEntity> imageList;
  void refreshImages() {
    var list = Directory(
      ref.watch(selectedDirProvider),
    ).listSync(recursive: true);
    list.removeWhere((item) => item is Directory);
    imageList = list;
  }

  List<Duration> timer = [
    Duration(seconds: 30),
    Duration(seconds: 60),
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 10),
  ];
  int timerIndex = 0;

  void openShow(context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ShowView(list: imageList)));
  }

  void openImage(context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowView(list: imageList, initialIndex: index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    refreshImages();
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(),
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MasonryGridView.count(
            crossAxisCount:
                ResponsiveBreakpoints.of(context).isDesktop
                    ? 4
                    : ResponsiveBreakpoints.of(context).isTablet
                    ? 3
                    : 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            itemCount: imageList.length,
            itemBuilder: (BuildContext context, int index) {
              var imageFile = imageList[index];
              return Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: OpenContainer(
                  closedColor: Theme.of(context).cardColor,
                  closedBuilder:
                      (context, action) => InkWell(
                        onTap: () => action(),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: FileImage(imageFile as File),
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                  openBuilder:
                      (context, action) =>
                          ShowView(list: imageList, initialIndex: index),
                ),
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
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              spacing: 4,
                              mainAxisSize: MainAxisSize.max,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.casino_outlined),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_downward),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_left),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.slideshow),
                                  onPressed: () {
                                    openShow(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    FloatingActionButton(
                      onPressed:
                          () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  return SizedBox(
                                    height: 360,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.timer_outlined),
                                          title: Text("Display each image for"),
                                          subtitle: Wrap(
                                            spacing: 2,
                                            children: [
                                              FilterChip(
                                                label: Text("30s"),
                                                selected: timerIndex == 0,
                                                onSelected:
                                                    (value) => setState(() {
                                                      timerIndex = 0;
                                                    }),
                                              ),
                                              FilterChip(
                                                label: Text("60s"),
                                                selected: timerIndex == 1,
                                                onSelected:
                                                    (value) => setState(() {
                                                      timerIndex = 1;
                                                    }),
                                              ),
                                              FilterChip(
                                                label: Text("2 mins"),
                                                selected: timerIndex == 2,
                                                onSelected:
                                                    (value) => setState(() {
                                                      timerIndex = 2;
                                                    }),
                                              ),
                                              FilterChip(
                                                label: Text("5 mins"),
                                                selected: timerIndex == 3,
                                                onSelected:
                                                    (value) => setState(() {
                                                      timerIndex = 3;
                                                    }),
                                              ),
                                              FilterChip(
                                                label: Text("10 mins"),
                                                selected: timerIndex == 4,
                                                onSelected:
                                                    (value) => setState(() {
                                                      timerIndex = 4;
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // ListTile(
                                        //   leading: Icon(Icons.image),
                                        //   title: Text("Number of images in practice"),
                                        // ),
                                        // ListTile(
                                        //   leading: Icon(Icons.all_inclusive),
                                        //   title: Text("Unlimited"),
                                        //   trailing: Radio(value: "unlimited",
                                        //   groupValue: "limit",
                                        //   onChanged: (value) {},),
                                        // ),
                                        // ListTile(
                                        //   leading: Icon(Icons.tag),
                                        //   title: Text("limited"),
                                        //   trailing: Radio(value: "unlimited",
                                        //   groupValue: "limit",
                                        //   onChanged: (value) {},),
                                        // ),
                                        FilledButtonLarge(
                                          label: "Start",
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: Icon(Icons.timer_outlined),
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
