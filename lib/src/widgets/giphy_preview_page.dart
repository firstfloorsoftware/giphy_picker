import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_image.dart';

/// Presents a Giphy preview image.
class GiphyPreviewPage extends StatelessWidget {
  final GiphyGif gif;
  final Widget? title;
  final AppBarBuilder appBarBuilder;
  final bool showGiphyAttribution;
  final ValueChanged<GiphyGif>? onSelected;

  const GiphyPreviewPage(
      {super.key,
      required this.gif,
      this.title,
      required this.appBarBuilder,
      this.showGiphyAttribution = true,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: appBarBuilder(context, title: title, actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => onSelected?.call(gif))
        ]),
        body: SafeArea(
          bottom: false,
          child: Center(
              child: GiphyImage.original(
            gif: gif,
            width: media.orientation == Orientation.portrait
                ? double.maxFinite
                : null,
            height: media.orientation == Orientation.landscape
                ? double.maxFinite
                : null,
            fit: BoxFit.contain,
            showGiphyAttribution: showGiphyAttribution,
          )),
        ));
  }
}
