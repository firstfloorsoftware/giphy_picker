import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget? title;

  const GiphySearchPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: title),
        body: SafeArea(
          bottom: GiphyContext.of(context).showGiphyAttribution,
          child: const GiphySearchView(),
        ),
      );
    });
  }
}
