import 'package:giphy_picker/src/model/client/gif.dart';

/// Represents a collection of GIF images, usually the result of a search operation.
class GiphyCollection {
  final List<GiphyGif> data;
  final GiphyPagination? pagination;
  final GiphyMeta? meta;

  GiphyCollection(
      {required this.data, required this.pagination, required this.meta});

  factory GiphyCollection.fromJson(Map<String, dynamic> json) {
    return GiphyCollection(
        data: json.containsKey('data')
            ? (json['data'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => GiphyGif.fromJson(e))
                .toList(growable: false)
            : List<GiphyGif>.empty(),
        pagination: json.containsKey('pagination')
            ? GiphyPagination.fromJson(
                json['pagination'] as Map<String, dynamic>)
            : null,
        meta: json.containsKey('meta')
            ? GiphyMeta.fromJson(json['meta'] as Map<String, dynamic>)
            : null);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'data': data, 'pagination': pagination, 'meta': meta};

  @override
  String toString() {
    return 'GiphyCollection{data: $data, pagination: $pagination, meta: $meta}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyCollection &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          pagination == other.pagination &&
          meta == other.meta;

  @override
  int get hashCode => data.hashCode ^ pagination.hashCode ^ meta.hashCode;
}

/// Contains information relating to the number of total results available as well as the number of results fetched and their relative positions.
class GiphyPagination {
  final int totalCount;
  final int count;
  final int offset;

  GiphyPagination(
      {required this.totalCount, required this.count, required this.offset});

  factory GiphyPagination.fromJson(Map<String, dynamic> json) =>
      GiphyPagination(
          totalCount: json['total_count'] as int? ?? 0,
          count: json['count'] as int? ?? 0,
          offset: json['offset'] as int? ?? 0);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total_count': totalCount,
      'count': count,
      'offset': offset
    };
  }

  @override
  String toString() {
    return 'GiphyPagination{totalCount: $totalCount, count: $count, offset: $offset}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyPagination &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          count == other.count &&
          offset == other.offset;

  @override
  int get hashCode => totalCount.hashCode ^ count.hashCode ^ offset.hashCode;
}

/// Contains basic information regarding the response and its status.
class GiphyMeta {
  final int status;
  final String msg;

  final String responseId;

  GiphyMeta(
      {required this.status, required this.msg, required this.responseId});

  factory GiphyMeta.fromJson(Map<String, dynamic> json) => GiphyMeta(
      status: json['status'] as int? ?? 0,
      msg: json['msg'] as String? ?? '',
      responseId: json['response_id'] as String? ?? '');

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'msg': msg,
      'response_id': responseId
    };
  }

  @override
  String toString() {
    return 'GiphyMeta{status: $status, msg: $msg, responseId: $responseId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyMeta &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          msg == other.msg &&
          responseId == other.responseId;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode ^ responseId.hashCode;
}
