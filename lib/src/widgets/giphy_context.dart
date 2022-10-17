import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:giphy_picker/src/widgets/giphy_search_text.dart';

typedef SearchTextBuilder = Widget Function(
    BuildContext context,
    TextEditingController controller,
    String? hintText,
    ValueChanged<String> onChanged);

typedef SearchLoadingBuilder = Widget Function(BuildContext context);

typedef SearchErrorBuilder = Widget Function(
    BuildContext context, Object error);

/// Provides the context for a Giphy search operation, and makes its data available to its widget sub-tree.
class GiphyContext extends InheritedWidget {
  final String apiKey;
  final String rating;
  final String language;
  final bool sticker;
  final ValueChanged<GiphyGif>? onSelected;
  final ErrorListener? onError;
  final bool showPreviewPage;
  final bool showGiphyAttribution;
  final String searchHintText;
  final GiphyPreviewType? previewType;
  final SearchTextBuilder searchTextBuilder;
  final SearchLoadingBuilder loadingBuilder;
  final SearchErrorBuilder errorBuilder;

  /// Debounce delay when searching
  final Duration searchDelay;

  const GiphyContext(
      {super.key,
      required super.child,
      required this.apiKey,
      this.rating = GiphyRating.g,
      this.language = GiphyLanguage.english,
      this.sticker = false,
      this.onSelected,
      this.onError,
      this.showPreviewPage = true,
      this.showGiphyAttribution = true,
      this.searchHintText = 'Search Giphy',
      this.searchDelay = const Duration(milliseconds: 500),
      this.previewType,
      SearchTextBuilder? searchTextBuilder,
      SearchLoadingBuilder? loadingBuilder,
      SearchErrorBuilder? errorBuilder})
      : searchTextBuilder = searchTextBuilder ?? _buildDefaultSearchText,
        loadingBuilder = loadingBuilder ?? _buildDefaultSearchLoading,
        errorBuilder = errorBuilder ?? _buildDefaultSearchError;

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

  static Widget _buildDefaultSearchText(
    BuildContext context,
    TextEditingController controller,
    String? hintText,
    ValueChanged<String> onChanged,
  ) =>
      GiphySearchText(
          controller: controller, hintText: hintText, onChanged: onChanged);

  static Widget _buildDefaultSearchLoading(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  static Widget _buildDefaultSearchError(BuildContext context, Object error) =>
      Center(
          child: Text(
        error.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).errorColor),
      ));
}
