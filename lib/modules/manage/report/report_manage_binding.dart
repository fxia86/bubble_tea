import 'package:bubble_tea/data/repositories/order_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/services/order_service.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:get/get.dart';

import 'report_manage_controller.dart';

class ReportManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => OrderService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut<ReportManageController>(() => ReportManageController());
  }
}
