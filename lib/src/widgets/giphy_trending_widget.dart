import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';

import '../../giphy_picker.dart';
import 'giphy_thumbnail.dart';

/// Provides the UI for searching Giphy gif images.
class GiphyTrendingWidget extends StatefulWidget {
  const GiphyTrendingWidget({
    Key? key,
    required this.apiKey,
    required this.onSelectedGif,
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

  /// function for selecting gif
  final Function(GiphyGif) onSelectedGif;

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
                    child: _GiphyThumbnailGrid(
                      key: Key('${snapshot.data.hashCode}'),
                      repo: snapshot.data!,
                      scrollController: _scrollController,
                      selectedGif: widget.onSelectedGif,
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
              : widget.noResultWidget ??
                  Center(
                    child: Text('No results'),
                  );
        } else if (snapshot.hasError) {
          return widget.errorWidget ??
              Center(
                child: Text('An error occurred'),
              );
        }
        return widget.loadingWidget ??
            Center(
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

/// A selectable grid view of gif thumbnails.
class _GiphyThumbnailGrid extends StatelessWidget {
  final GiphyRepository repo;
  final ScrollController? scrollController;
  final Function(GiphyGif) selectedGif;

  const _GiphyThumbnailGrid({
    Key? key,
    required this.repo,
    required this.selectedGif,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      controller: scrollController,
      itemCount: repo.totalCount,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        child: GiphyThumbnail(key: Key('$index'), repo: repo, index: index),
        onTap: () async {
          final gif = await repo.get(index);
          selectedGif(gif);
        },
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        childAspectRatio: 1.6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
