import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/repositories/supplier_repository.dart';
import 'package:bubble_tea/data/services/material_service.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:bubble_tea/data/services/supplier_service.dart';
import 'package:get/get.dart';

import 'material_manage_controller.dart';

class MaterialManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => SupplierService());
    Get.lazyPut(() => MaterialService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut(() => SupplierRepository());
    Get.lazyPut(() => MaterialRepository());
    Get.lazyPut<MaterialManageController>(() => MaterialManageController());
  }
}
