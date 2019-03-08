library giphy_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_page.dart';

export 'package:giphy_picker/src/widgets/giphy_image.dart';

/// Provides Giphy picker functionality.
class GiphyPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static Future<GiphyGif> pickGif(
      {@required BuildContext context,
      @required String apiKey,
      String rating = GiphyRating.g,
      String lang = GiphyLanguage.english,
      Widget title}) async {
    GiphyGif result;

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => GiphyContext(
                child: GiphySearchPage(),
                apiKey: apiKey,
                rating: rating,
                language: lang,
                onSelected: (gif) {
                  result = gif;

                  Navigator.popUntil(context, (Route route) => route.isFirst);
                }),
            fullscreenDialog: true));

    return result;
  }
}
