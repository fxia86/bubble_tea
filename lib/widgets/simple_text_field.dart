import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    Key? key,
    this.initialValue,
    this.labelText,
    this.prefixText,
    this.suffixText,
    this.enable = true,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
  }) : super(key: key);

  final String? initialValue;
  final String? labelText;
  final String? prefixText;
  final String? suffixText;
  final bool? enable;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    var formatter = <TextInputFormatter>[LengthLimitingTextInputFormatter(200)];
    if (inputFormatters != null) {
      formatter.addAll(inputFormatters!);
    }
    return TextFormField(
      enabled: enable,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: 20),
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: !enable!,
        prefixText: prefixText,
        prefixStyle: TextStyle(fontSize: 20, color: Colors.black87),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: enable! ? 20 : 24),
        suffixText: suffixText,
        suffixStyle: TextStyle(fontSize: 20),
      ),
      inputFormatters: formatter,
      // validator: (val) {
      //   if (val!.isEmpty) {
      //     return "It's Empty";
      //   }
      // },
      onChanged: onChanged,
    );
  }
}

class MoneyTextField extends StatelessWidget {
  const MoneyTextField({
    Key? key,
    this.initialValue,
    this.labelText,
    this.enable = true,
    this.onChanged,
  }) : super(key: key);

  final String? initialValue;
  final String? labelText;
  final bool? enable;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      enable: enable,
      initialValue: initialValue,
      labelText: labelText,
      prefixText: "€  ",
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        LengthLimitingTextInputFormatter(9),
        MoneyTextInputFormatter()
      ],
    );
  }
}

// 需要配合以下限制
// FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
// LengthLimitingTextInputFormatter(9),
class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newvalueText = newValue.text;

    if (newvalueText == ".") {
      //第一个数为.
      newvalueText = "0.";
    } else if (newvalueText.contains(".")) {
      if (newvalueText.lastIndexOf(".") != newvalueText.indexOf(".")) {
        //输入了2个小数点
        newvalueText = newvalueText.substring(0, newvalueText.lastIndexOf('.'));
      } else if (newvalueText.length - 1 - newvalueText.indexOf(".") > 2) {
        //输入了1个小数点 小数点后两位
        newvalueText = newvalueText.substring(0, newvalueText.indexOf(".") + 3);
      }
    }

    return TextEditingValue(
      text: newvalueText,
      selection: new TextSelection.collapsed(offset: newvalueText.length),
    );
  }
}

class IntegerTextField extends StatelessWidget {
  const IntegerTextField({
    Key? key,
    this.initialValue,
    this.labelText,
    this.enable = true,
    this.onChanged,
  }) : super(key: key);

  final String? initialValue;
  final String? labelText;
  final bool? enable;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      enable: enable,
      initialValue: initialValue,
      labelText: labelText,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(9),
        IntegerTextInputFormatter()
      ],
    );
  }
}

class IntegerTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newvalueText = newValue.text;

    if (newvalueText == "0") {
      newvalueText = "";
    }

    return TextEditingValue(
      text: newvalueText,
      selection: new TextSelection.collapsed(offset: newvalueText.length),
    );
  }
}
