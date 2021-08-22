import 'package:bubble_tea/widgets/navi_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'special_manage_controller.dart';

class SpecialManagePage extends GetView<SpecialManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Special Manage"),
      ),
      drawer: Drawer(
        child: NaviBar(),
      ),
      body: Center(
        child: Text("Special Manage"),
      ),
    );
  }
}
