import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

/// The giphy search page.
class GiphySearchPage extends StatelessWidget {
  final Widget? title;

  const GiphySearchPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final giphy = GiphyContext.of(context);
    return Scaffold(
      appBar: giphy.appBarBuilder(context, title: title),
      body: SafeArea(
        bottom: giphy.showGiphyAttribution,
        child: const GiphySearchView(),
      ),
    );
  }
}
