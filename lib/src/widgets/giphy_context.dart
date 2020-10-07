import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:giphy_picker/src/model/giphy_decorator.dart';

/// Provides the context for a Giphy search operation, and makes its data available to its widget sub-tree.
class GiphyContext extends InheritedWidget {
  final String apiKey;
  final String rating;
  final String language;
  final bool sticker;
  final ValueChanged<GiphyGif> onSelected;
  final ErrorListener onError;
  final bool showPreviewPage;
  final GiphyDecorator decorator;
  final String searchText;
  final GiphyPreviewType previewType;

  /// Debounce delay when searching
  final Duration searchDelay;

  const GiphyContext({
    Key key,
    @required Widget child,
    @required this.apiKey,
    this.rating = GiphyRating.g,
    this.language = GiphyLanguage.english,
    this.sticker = false,
    this.onSelected,
    this.onError,
    this.showPreviewPage = true,
    this.searchText = 'Search Giphy',
    this.searchDelay,
    this.decorator,
    this.previewType,
  }) : super(key: key, child: child);

  void select(GiphyGif gif) {
    if (onSelected != null) {
      onSelected(gif);
    }
  }

  void error(dynamic error) {
    if (onError != null) {
      onError(error);
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static GiphyContext of(BuildContext context) {
    final settings = context
        .getElementForInheritedWidgetOfExactType<GiphyContext>()
        ?.widget as GiphyContext;

    if (settings == null) {
      throw 'Required GiphyContext widget not found. Make sure to wrap your widget with GiphyContext.';
    }
    return settings;
  }
}
