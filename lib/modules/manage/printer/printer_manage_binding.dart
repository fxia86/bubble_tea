import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/data/services/printer_service.dart';
import 'package:get/get.dart';

import 'printer_manage_controller.dart';

class PrinterManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrinterService());
    Get.lazyPut(() => PrinterRepository());
    Get.lazyPut<PrinterManageController>(() => PrinterManageController());
  }
}
