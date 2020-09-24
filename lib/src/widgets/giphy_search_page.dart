import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget title;
  final TextStyle searchInputTextStyle;
  final Color appBarBackgroundColor;

  const GiphySearchPage({
    this.title,
    this.searchInputTextStyle,
    this.appBarBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    assert(appBarBackgroundColor != null);
    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: appBarBackgroundColor,
      ),
      body: SafeArea(
        child: GiphySearchView(
          searchTextStyle: searchInputTextStyle,
        ),
        bottom: false,
      ),
    );
  }
}
