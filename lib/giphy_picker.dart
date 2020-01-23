library giphy_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_page.dart';

export 'package:giphy_picker/src/widgets/giphy_image.dart';

typedef ErrorListener = void Function(dynamic error);

/// Provides Giphy picker functionality.
class GiphyPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static Future<GiphyGif> pickGif({
    @required BuildContext context,
    @required String apiKey,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    Widget title,
    ErrorListener onError,
    bool showPreviewPage = true,
    String searchText = 'Search GIPHY',
  }) async {
    GiphyGif result;

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => GiphyContext(
                  child: GiphySearchPage(),
                  apiKey: apiKey,
                  rating: rating,
                  language: lang,
                  onError:
                      onError ?? (error) => _showErrorDialog(context, error),
                  onSelected: (gif) {
                    result = gif;

                    // pop preview page if necessary
                    if (showPreviewPage) {
                      Navigator.pop(context);
                    }
                    // pop giphy_picker
                    Navigator.pop(context);
                  },
                  showPreviewPage: showPreviewPage,
                  searchText: searchText,
                ),
            fullscreenDialog: true));

    return result;
  }

  static void _showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Giphy error'),
          content: new Text('An error occurred. $error'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
