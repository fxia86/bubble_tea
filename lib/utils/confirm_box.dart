import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmBox {
  static const String _title = "Are you sure ?";

  static void show(String? text, VoidCallback? onConfirm) {
    hide();
    Get.dialog(
      ConfirmDialog(
        title: _title,
        text: "Are you sure to delete '$text' ?",
        onConfirm: onConfirm,
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.text,
    required this.onConfirm,
  }) : super(key: key);

  final String title;
  final String text;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => true,
      child: AlertDialog(
        key: key,
        title: Text(title, style: TextStyle(fontSize: 24)),
        content: Text(text, style: TextStyle(fontSize: 20)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(fontSize: 20,color: Colors.black54)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('OK', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
