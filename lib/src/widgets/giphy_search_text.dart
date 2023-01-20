import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';

/// Provides a default text editor implementation for search operations.
class GiphySearchText extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const GiphySearchText({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: GiphyContext.of(context).searchHintText,
          ),
          onChanged: onChanged),
    );
  }
}
