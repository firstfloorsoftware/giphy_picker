import 'package:flutter/material.dart';

// A nicely formatted error view, used in case things go south.
class GiphyErrorView extends StatelessWidget {
  final Object error;
  final Function()? retry;
  final Color? color;

  const GiphyErrorView({
    super.key,
    required this.error,
    this.retry,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error, color: c, size: 64),
        const SizedBox(height: 10),
        Text(
          error.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: c),
        )
      ]),
    );
  }
}
