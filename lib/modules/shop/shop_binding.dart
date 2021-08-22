import 'package:bubble_tea/data/services/shop/shop_service.dart';
import 'package:bubble_tea/data/repositories/shop/shop_repository.dart';
import 'package:get/get.dart';

import 'shop_controller.dart';

class ShopBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopService());
    Get.lazyPut(() => ShopRepository());
    Get.lazyPut<ShopController>(() => ShopController());
  }
}
