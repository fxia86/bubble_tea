import 'package:flutter/material.dart';

class SimpleTextInput extends StatelessWidget {
  const SimpleTextInput(
      {Key? key,
      required this.labelText,
      required this.initialValue,
      this.suffixText = "",
      this.enable = true,
      this.maxline = 1,
      this.keyboardType = TextInputType.text,
      this.onChanged})
      : super(key: key);

  final String? initialValue;
  final String labelText;
  final String? suffixText;
  final bool? enable;
  final int maxline;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: 20),
      maxLines: maxline,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // filled: true,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: enable! ? 20 : 30),
        suffixText: suffixText,
        suffixStyle: TextStyle(fontSize: 20),
      ),
      // validator: (val) {
      //   if (val!.isEmpty) {
      //     return "It's Empty";
      //   }
      // },
      onChanged: onChanged,
    );
  }
}
