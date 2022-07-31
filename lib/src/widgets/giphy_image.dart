import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:giphy_picker/src/model/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_overlay.dart';

/// Loads and renders a Giphy image.
class GiphyImage extends StatefulWidget {
  final String? url;
  final Widget? placeholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool renderGiphyOverlay;

  /// Loads an image from given url.
  const GiphyImage(
      {super.key,
      this.url,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true});

  /// Loads the original image for given Giphy gif.
  GiphyImage.original(
      {Key? key,
      required GiphyGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.images.original?.url,
        super(key: key ?? Key(gif.id));

  /// Loads the original still image for given Giphy gif.
  GiphyImage.originalStill(
      {Key? key,
      required GiphyGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.images.originalStill?.url,
        super(key: key ?? Key(gif.id));

  @override
  State<GiphyImage> createState() => _GiphyImageState();

  /// Loads the images bytes for given url from Giphy.
  static Future<Uint8List?> load(String? url, {Client? client}) async {
    if (url == null) {
      return null;
    }
    final response = await (client ?? Client())
        .get(Uri.parse(url), headers: {'accept': 'image/*'});

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }
}

class _GiphyImageState extends State<GiphyImage> {
  late Future<Uint8List?> _loadImage;

  @override
  void initState() {
    _loadImage = GiphyImage.load(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _loadImage,
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          final image = Image.memory(snapshot.data!,
              width: widget.width, height: widget.height, fit: widget.fit);

          if (widget.renderGiphyOverlay) {
            return GiphyOverlay(child: image);
          }
          return image;
        }
        return widget.placeholder ??
            const Center(child: CircularProgressIndicator());
      });
}
