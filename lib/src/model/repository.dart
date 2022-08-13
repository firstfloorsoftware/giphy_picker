import 'dart:async';
import 'dart:collection';

import 'package:giphy_picker/giphy_picker.dart';

/// A general-purpose repository with support for on-demand paged retrieval and caching of values of type T.
abstract class Repository<T> {
  final HashMap<int, T> _cache = HashMap<int, T>();
  final Set<int> _pagesLoading = <int>{};
  final HashMap<int, Completer<T>> _completers = HashMap<int, Completer<T>>();
  final int pageSize;
  final ErrorListener? onError;
  int _totalCount = 0;

  Repository({required this.pageSize, this.onError});

  /// The total number of values available.
  int get totalCount => _totalCount;

  /// Asynchronously retrieves the value at specified index. When not available in local cache
  /// the page containing the value is retrieved.
  Future<T> get(int index) {
    // index must within bounds
    assert(index == 0 || index > 0 && index < _totalCount);

    final value = _cache[index];

    // value is availableÍ
    if (value != null) {
      return Future.value(value);
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
      completer = Completer<T>();
      _completers[index] = completer;
    }

    return completer.future;
  }

  void _onPageRetrieved(Page<T> page) {
    _totalCount = page.totalCount;
    _pagesLoading.remove(page.page);

    if (_totalCount == 0) {
      // complete all with null
      for (var c in _completers.values) {
        c.complete(null);
      }
      _completers.clear();
    } else {
      for (var i = 0; i < page.values.length; i++) {
        // store value
        final index = page.page * pageSize + i;
        final value = page.values[i];
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
