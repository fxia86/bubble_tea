import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';

class QrcodeScanner extends StatefulWidget {
  const QrcodeScanner({Key? key, required this.onCapture}) : super(key: key);

  final Function(String? val)? onCapture;

  @override
  _QrcodeScannerState createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrcodeScanner> {
  @override
  void dispose() {
    if (Get.context!.isPortrait) {
      //横屏
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: Get.width * 0.5,
      // height: Get.height * 0.5,
      child: ScanView(
        onCapture: widget.onCapture,
      ),
    );
  }
}
