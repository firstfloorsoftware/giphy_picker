import 'dart:async';

import 'package:flutter/foundation.dart';

/// Debouncer created to wait some time before executing an action
class Debouncer {
  final Duration _delay;
  Timer? _timer;

  Debouncer({
    Duration delay = const Duration(milliseconds: 500),
  }) : _delay = delay;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
