import 'dart:async';
import 'dart:convert';
import 'package:giphy_picker/src/model/client/collection.dart';
import 'package:giphy_picker/src/model/client/gif.dart';
import 'package:giphy_picker/src/model/client/languages.dart';
import 'package:giphy_picker/src/model/client/rating.dart';
import 'package:http/http.dart';

class GiphyClient {
  static final baseUri = Uri(scheme: 'https', host: 'api.giphy.com');

  final String _apiKey;
  final Client _client;

  GiphyClient({
    required String apiKey,
    Client? client,
  })  : _apiKey = apiKey,
        _client = client ?? Client();

  Future<GiphyCollection> trending({
    int offset = 0,
    int limit = 30,
    String rating = GiphyRating.g,
    bool sticker = false,
  }) async {
    return _fetchCollection(
      baseUri.replace(
        path: sticker ? 'v1/stickers/trending' : 'v1/gifs/trending',
        queryParameters: <String, String>{
          'offset': '$offset',
          'limit': '$limit',
          'rating': rating,
        },
      ),
    );
  }

  Future<GiphyCollection> search(
    String query, {
    int offset = 0,
    int limit = 30,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    bool sticker = false,
  }) async {
    return _fetchCollection(
      baseUri.replace(
        path: sticker ? 'v1/stickers/search' : 'v1/gifs/search',
        queryParameters: <String, String>{
          'q': query,
          'offset': '$offset',
          'limit': '$limit',
          'rating': rating,
          'lang': lang,
        },
      ),
    );
  }

  Future<GiphyGif> random({
    String? tag,
    String rating = GiphyRating.g,
    bool sticker = false,
  }) async {
    return _fetchGif(
      baseUri.replace(
        path: sticker ? 'v1/stickers/random' : 'v1/gifs/random',
        queryParameters: <String, String>{
          if (tag != null) 'tag': tag,
          'rating': rating,
        },
      ),
    );
  }

  Future<GiphyGif> byId(String id) async =>
      _fetchGif(baseUri.replace(path: 'v1/gifs/$id'));

  Future<GiphyGif> _fetchGif(Uri uri) async {
    final response = await _getWithAuthorization(uri);

    return GiphyGif.fromJson((json.decode(response.body)
        as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<GiphyCollection> _fetchCollection(Uri uri) async {
    final response = await _getWithAuthorization(uri);

    return GiphyCollection.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Response> _getWithAuthorization(Uri uri) async {
    final uriString = uri
        .replace(
          queryParameters: Map<String, String>.from(uri.queryParameters)
            ..putIfAbsent('api_key', () => _apiKey),
        )
        .toString();

    try {
      final response = await _client.get(Uri.parse(uriString));
      if (response.statusCode == 200) {
        return response;
      }
      throw GiphyError.fromJson(response.statusCode,
          json.decode(response.body) as Map<String, dynamic>);
    } on GiphyError {
      rethrow;
    } catch (e) {
      throw GiphyError(-1, e.toString());
    }
  }
}

class GiphyError {
  final int statusCode;
  final String message;

  GiphyError(this.statusCode, this.message);

  factory GiphyError.fromJson(int statusCode, Map<String, dynamic> json) {
    final meta = json.containsKey('meta')
        ? GiphyMeta.fromJson(json['meta'] as Map<String, dynamic>)
        : null;

    if (meta != null) {
      return GiphyError(meta.status, meta.msg);
    }
    return GiphyError(statusCode, 'Unknown error');
  }

  @override
  String toString() {
    return '$message (status $statusCode)';
  }
}
