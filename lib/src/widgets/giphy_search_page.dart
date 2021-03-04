import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';
import 'giphy_context.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget? title;

  const GiphySearchPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final giphyDecorator = GiphyContext.of(context).decorator;
      return Theme(
        data: giphyDecorator.giphyTheme ?? Theme.of(context),
        child: Scaffold(
          appBar: giphyDecorator.showAppBar ? AppBar(title: title) : null,
          body: SafeArea(
            child: GiphySearchView(),
            bottom: false,
          ),
        ),
      );
    });
  }
}
