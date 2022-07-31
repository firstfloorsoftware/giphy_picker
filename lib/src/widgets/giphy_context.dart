import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

/// Provides the context for a Giphy search operation, and makes its data available to its widget sub-tree.
class GiphyContext extends InheritedWidget {
  final String apiKey;
  final String rating;
  final String language;
  final bool sticker;
  final ValueChanged<GiphyGif>? onSelected;
  final ErrorListener? onError;
  final bool showPreviewPage;
  final GiphyDecorator decorator;
  final String searchText;
  final GiphyPreviewType? previewType;

  /// Debounce delay when searching
  final Duration searchDelay;

  const GiphyContext({
    super.key,
    required super.child,
    required this.apiKey,
    this.rating = GiphyRating.g,
    this.language = GiphyLanguage.english,
    this.sticker = false,
    this.onSelected,
    this.onError,
    this.showPreviewPage = true,
    this.searchText = 'Search Giphy',
    this.searchDelay = const Duration(milliseconds: 500),
    required this.decorator,
    this.previewType,
  });

  void select(GiphyGif gif) => onSelected?.call(gif);
  void error(dynamic error) => onError?.call(error);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static GiphyContext of(BuildContext context) {
    final giphy = context
        .getElementForInheritedWidgetOfExactType<GiphyContext>()
        ?.widget as GiphyContext?;

    if (giphy == null) {
      throw 'Required GiphyContext widget not found. Make sure to wrap your widget with GiphyContext.';
    }
    return giphy;
  }
}
