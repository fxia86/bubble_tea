import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleTextInput extends StatelessWidget {
  const SimpleTextInput(
      {Key? key,
      required this.labelText,
      required this.initialValue,
      this.prefixText = "",
      this.suffixText = "",
      this.enable = true,
      this.maxLines = 1,
      this.maxLength,
      this.keyboardType = TextInputType.text,
      this.onChanged})
      : super(key: key);

  final String? initialValue;
  final String labelText;
  final String? prefixText;
  final String? suffixText;
  final bool? enable;
  final int maxLines;
  final int? maxLength;
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
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // filled: true,
        prefixText: prefixText,
        prefixStyle:TextStyle(fontSize: 20,color: Colors.black87),
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
