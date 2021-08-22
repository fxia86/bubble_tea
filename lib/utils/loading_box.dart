import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingBox {
  static void show() {
    hide();
    Get.dialog(LoadingDialog(), barrierColor: Colors.transparent);
  }

  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        key: key,
        backgroundColor: Colors.black38,
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
