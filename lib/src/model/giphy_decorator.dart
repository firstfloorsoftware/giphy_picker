import 'package:flutter/material.dart';

/// Decorator for the Giphy Picker
/// Here you can enable/disable some properties like the `AppBar` and elevation for the search `TextField` field.
/// You can also customize the Giphy Picker using `ThemeData`

class GiphyDecorator {
  /// Display or not the `AppBar`, it's [true] by default
  final bool showAppBar;

  /// Set a custom theme if you want to customize the views with your own style.
  final ThemeData? giphyTheme;

  /// Set an elevation for the search `TextField`, it's [0.0] by default
  final double searchElevation;

  const GiphyDecorator({
    this.showAppBar = true,
    this.giphyTheme,
    this.searchElevation = 0.0,
  });
}
