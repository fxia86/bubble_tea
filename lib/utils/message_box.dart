import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBox {
  static void info([String title = "", String message = ""]) {
    _show(title, message);
  }

  static void success([String title = "", String message = ""]) {
    _show(title, message, Colors.green);
  }

  static void warn([String title = "", String message = ""]) {
    _show(title, message, Colors.orangeAccent);
  }

  static void error([String title = "", String message = ""]) {
    _show(title, message, Colors.redAccent);
  }

  static void _show(String title, String message, [Color? color]) {
    if (title.isEmpty && message.isEmpty) return;

    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: color,
      titleText: title.isEmpty
          ? SizedBox()
          : Text(
              title,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
      messageText: message.isEmpty
          ? SizedBox()
          : Text(
              message,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
    );
  }

  static void hide() {
    if (Get.isSnackbarOpen!) {
      Get.back();
    }
  }
}
