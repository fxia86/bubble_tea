import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CellText extends StatelessWidget {
  const CellText(this.text,
      {Key? key, this.fontSize = 20, this.colored = false})
      : super(key: key);
  final String? text;
  final double fontSize;
  final bool colored;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      overflow: TextOverflow.ellipsis,
      style: colored
          ? TextStyle(fontSize: fontSize, color: Get.theme.primaryColor)
          : TextStyle(fontSize: fontSize),
    );
  }
}
