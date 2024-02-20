import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_preview_page.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail.dart';

/// A selectable grid view of gif thumbnails.
class GiphyThumbnailGrid extends StatefulWidget {
  final GiphyRepository repo;
  final ScrollController? scrollController;

  /// Creates a grid for given repository.
  const GiphyThumbnailGrid(
      {super.key, required this.repo, this.scrollController});

  @override
  State<GiphyThumbnailGrid> createState() => _GiphyThumbnailGridState();
}

class _GiphyThumbnailGridState extends State<GiphyThumbnailGrid> {
  @override
  Widget build(BuildContext context) {
    final giphy = GiphyContext.of(context);
    return GridView.builder(
        padding: EdgeInsets.fromLTRB(
          10,
          10,
          10,
          // bottom padding takes attribution into account
          giphy.showGiphyAttribution ? 34 : 10,
        ),
        controller: widget.scrollController,
        itemCount: widget.repo.totalCount,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: GiphyThumbnail(
                key: Key('$index'), repo: widget.repo, index: index),
            onTap: () async {
              // display preview page
              final giphy = GiphyContext.of(context);
              final gif = await widget.repo.get(index);
              if (gif != null) {
                if (context.mounted && giphy.showPreviewPage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => GiphyPreviewPage(
                        gif: gif,
                        showGiphyAttribution: giphy.showGiphyAttribution,
                        onSelected: giphy.onSelected,
                        title: gif.title?.isNotEmpty == true
                            ? Text(gif.title!)
                            : null,
                      ),
                    ),
                  );
                } else {
                  giphy.onSelected?.call(gif);
                }
              }
            }),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            childAspectRatio: 1.6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5));
  }
}
