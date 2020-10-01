import 'package:flutter/material.dart';

class GiphyDecorator {
  const GiphyDecorator(
      {this.showAppBar = true, this.giphyTheme, this.searchElevation = 0.0});

  final bool showAppBar;
  final ThemeData giphyTheme;
  final double searchElevation;
}
