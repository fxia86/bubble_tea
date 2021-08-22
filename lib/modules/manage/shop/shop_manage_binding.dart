import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:bubble_tea/modules/manage/shop/shop_manage_controller.dart';
import 'package:get/get.dart';

class ShopManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut<ShopManageController>(() => ShopManageController());
  }
}
