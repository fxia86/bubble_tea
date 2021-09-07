import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/repositories/user_repository.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:bubble_tea/data/services/user_service.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_controller.dart';
import 'package:get/get.dart';

class StaffManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => UserService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut(() => UserRepository());
    Get.lazyPut<StaffManageController>(() => StaffManageController());
  }
}
