import 'package:command_accepted/utils/colors_fonts.dart';
import 'package:flutter/material.dart';

class TextFormInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String? labelText;
  final TextInputType textInputType;
  final int maxLines;
  final String? hintText;
  final Iterable<String>? autoFillHints;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final String? prefixText;
  final bool readonly;
  final Function(String?)? onChanged;
  final Function(String?)? onSubmit;
  const TextFormInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    this.labelText,
    required this.textInputType,
    this.maxLines = 1,
    this.hintText,
    this.autoFillHints,
    this.onTap,
    this.validator,
    this.prefixText,
    this.readonly = false,
    this.onChanged,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<TextFormInput> createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {
  bool _isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixText == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.prefixText!,
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
        hintText: widget.hintText,
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  _isPasswordShown ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordShown = !_isPasswordShown;
                  });
                },
              )
            : const SizedBox(),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass && !_isPasswordShown,
      autocorrect: false,
      obscuringCharacter: "•",
      maxLines: widget.maxLines,
      autofillHints: widget.autoFillHints,
      onTap: widget.onTap,
      validator: widget.validator,
      readOnly: widget.readonly,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmit,
    );
  }
}
