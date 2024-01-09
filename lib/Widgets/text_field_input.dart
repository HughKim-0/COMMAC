import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String? labelText;
  final TextInputType textInputType;
  final int maxLines;
  final String? hintText;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    this.labelText,
    required this.textInputType,
    this.maxLines = 1,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      maxLines: maxLines,
    );
  }
}
