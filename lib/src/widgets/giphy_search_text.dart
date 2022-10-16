import 'package:flutter/material.dart';

class GiphySearchText extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const GiphySearchText(
      {super.key, required this.controller, this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          onChanged: onChanged),
    );
  }
}
