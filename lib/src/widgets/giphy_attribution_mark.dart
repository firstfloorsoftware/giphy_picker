import 'package:flutter/material.dart';

/// Renders the 'Powered by GIPHY' attribution mark over its content
class GiphyAttributionMark extends StatelessWidget {
  final Widget? child;

  const GiphyAttributionMark({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      if (child != null) child!,
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 24,
          child: IgnorePointer(
              child: Container(
                  alignment: Alignment.bottomLeft,
                  color: Colors.black54,
                  child: Image.asset(
                    'assets/PoweredBy_200px-Black_HorizText.png',
                    package: 'giphy_picker',
                    width: 200,
                    height: 22,
                  ))))
    ]);
  }
}
