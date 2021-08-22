import 'package:bubble_tea/data/repositories/supplier_repository.dart';
import 'package:bubble_tea/data/services/supplier_service.dart';
import 'package:bubble_tea/modules/manage/supplier/supplier_manage_controller.dart';
import 'package:get/get.dart';

class SupplierManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplierService());
    Get.lazyPut(() => SupplierRepository());
    Get.lazyPut<SupplierManageController>(() => SupplierManageController());
  }
}
