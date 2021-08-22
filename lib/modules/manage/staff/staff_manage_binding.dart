import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/repositories/staff_repository.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:bubble_tea/data/services/staff_service.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_controller.dart';
import 'package:get/get.dart';

class StaffManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => StaffService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut(() => StaffRepository());
    Get.lazyPut<StaffManageController>(() => StaffManageController());
  }
}
