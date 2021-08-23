import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_manage_controller.dart';

class OptionalForm extends StatelessWidget {
  final controller = Get.find<MenuManageController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: context.height,
      padding: EdgeInsets.all(20),
      child: Text("data"),
    );
  }
}
