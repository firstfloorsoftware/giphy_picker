library giphy_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_client.dart';
import 'package:giphy_picker/src/model/giphy_preview_types.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_page.dart';

export 'package:giphy_picker/src/model/giphy_client.dart';
export 'package:giphy_picker/src/widgets/giphy_image.dart';
export 'package:giphy_picker/src/model/giphy_preview_types.dart';

typedef ErrorListener = void Function(GiphyError error);

/// Provides Giphy picker functionality.
class GiphyPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static Future<GiphyGif?> pickGif({
    required BuildContext context,
    required String apiKey,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    bool sticker = false,
    Widget? title,
    ErrorListener? onError,
    bool showPreviewPage = true,
    bool showGiphyAttribution = true,
    bool fullScreenDialog = true,
    String searchHintText = 'Search GIPHY',
    GiphyPreviewType previewType = GiphyPreviewType.previewWebp,
  }) async {
    GiphyGif? result;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GiphyContext(
          previewType: previewType,
          apiKey: apiKey,
          rating: rating,
          language: lang,
          sticker: sticker,
          onError: onError ?? (error) => _showErrorDialog(context, error),
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
          showGiphyAttribution: showGiphyAttribution,
          searchHintText: searchHintText,
          child: GiphySearchPage(
            title: title,
          ),
        ),
        fullscreenDialog: fullScreenDialog,
      ),
    );

    return result;
  }

  static void _showErrorDialog(BuildContext context, GiphyError error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Giphy error'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
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
