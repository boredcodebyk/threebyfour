import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(title: Text("About")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "3/4",
                        style: TextStyle(
                          fontFamily: "Staatliches",
                          fontSize:
                              Theme.of(
                                context,
                              ).textTheme.displayLarge!.fontSize,
                        ),
                      ),
                    ),
                    Center(
                      child: Text("boredcodebyk"),
                    )
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
