import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaleIconButton extends StatelessWidget {
  const ScaleIconButton({Key? key, this.onPressed, this.icon, this.color})
      : super(key: key);

  final onPressed;
  final icon;
  final color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
      iconSize: Get.theme.iconTheme.size!,
    );
  }
}
