import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:giphy_picker/giphy_picker.dart';

/// A general-purpose repository with support for on-demand paged retrieval and caching of values of type T.
abstract class Repository<T> {
  final HashMap<int, T?> _cache = HashMap<int, T?>();
  final Set<int> _pagesLoading = <int>{};
  final HashMap<int, Completer<T?>> _completers = HashMap<int, Completer<T?>>();
  final int pageSize;
  final int maxTotalCount;
  final ErrorListener? onError;
  int _totalCount = 0;

  Repository(
      {required this.pageSize, required this.maxTotalCount, this.onError});

  /// The total number of values available.
  int get totalCount => _totalCount;

  /// Asynchronously retrieves the value at specified index. When not available in local cache
  /// the page containing the value is retrieved.

  Future<T?> get(int index) {
    // index must within bounds
    assert(index == 0 || index > 0 && index < _totalCount);

    // consult cache
    if (_cache.containsKey(index)) {
      return Future.value(_cache[index]);
    }

    final page = index ~/ pageSize;

    // value is not available, retrieve page
    if (!_pagesLoading.contains(page)) {
      _pagesLoading.add(page);
      getPage(page).then(_onPageRetrieved,
          onError: (error, stackTrace) =>
              _onPageError(page, error, stackTrace));
    }

    // value is being retrieved
    var completer = _completers[index];
    if (completer == null) {
      completer = Completer<T?>();
      _completers[index] = completer;
    }

    return completer.future;
  }

  void _onPageRetrieved(Page<T> page) {
    _pagesLoading.remove(page.page);

    // set total count once, and limit to max total
    if (_totalCount == 0) {
      _totalCount = min(maxTotalCount, page.totalCount);
    }
    if (_totalCount == 0) {
      // complete all with null
      for (var c in _completers.values) {
        c.complete(null);
      }
      _completers.clear();
    } else {
      for (var i = 0; i < pageSize; i++) {
        final index = page.page * pageSize + i;

        // cache value, use null if not found
        final value = i < page.values.length ? page.values[i] : null;
        _cache[index] = value;

        // complete optional completer
        final completer = _completers.remove(index);
        completer?.complete(value);
      }
    }
  }

  void _onPageError(int page, Object error, StackTrace stackTrace) {
    _pagesLoading.remove(page);

    // complete completers of this page with an error
    for (var i = 0; i < pageSize; i++) {
      final index = page * pageSize + i;
      final completer = _completers.remove(index);
      completer?.completeError(error, stackTrace);
    }

    // use custom error handler if available
    onError?.call(error);
  }

  Future<Page<T>> getPage(int page);
}

/// Represents a page of values.
class Page<T> {
  final List<T> values;
  final int page;
  final int totalCount;

  const Page(this.values, this.page, this.totalCount);
}
