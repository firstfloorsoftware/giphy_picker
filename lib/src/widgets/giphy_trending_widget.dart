import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail_grid.dart';

import '../../giphy_picker.dart';

/// Provides the UI for searching Giphy gif images.
class GiphyTrendingWidget extends StatefulWidget {
  const GiphyTrendingWidget({
    Key? key,
    required this.apiKey,
    this.loadingWidget,
    this.noResultWidget,
    this.errorWidget,
  }) : super(key: key);

  final String apiKey;

  /// for showing loading widget
  final Widget? loadingWidget;

  /// for no result widget
  final Widget? noResultWidget;

  /// for error widget
  final Widget? errorWidget;

  @override
  _GiphyTrendingWidgetState createState() => _GiphyTrendingWidgetState();
}

class _GiphyTrendingWidgetState extends State<GiphyTrendingWidget> {
  final _scrollController = ScrollController();
  final _repoController = StreamController<GiphyRepository>();

  @override
  void initState() {
    // initiate search on next frame (we need context)
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _search();
    });
    super.initState();
  }

  @override
  void dispose() {
    _repoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _repoController.stream,
      builder: (BuildContext context, AsyncSnapshot<GiphyRepository> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.totalCount > 0
              ? NotificationListener(
                  child: RefreshIndicator(
                    child: GiphyThumbnailGrid(
                      key: Key('${snapshot.data.hashCode}'),
                      repo: snapshot.data!,
                      scrollController: _scrollController,
                    ),
                    onRefresh: _search,
                  ),
                  onNotification: (n) {
                    // hide keyboard when scrolling
                    if (n is UserScrollNotification) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      return true;
                    }
                    return false;
                  },
                )
              : Center(
                  child: Text('No results'),
                );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future _search() async {
    try {
      // search, or trending when term is empty
      final repo = await GiphyRepository.trending(
        apiKey: widget.apiKey,
        rating: GiphyRating.g,
        sticker: false,
        previewType: GiphyPreviewType.previewGif,
        onError: (_) {},
      );

      // scroll up
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      if (mounted) {
        _repoController.add(repo);
      }
    } catch (error) {
      if (mounted) {
        _repoController.addError(error);
      }
    }
  }
}
