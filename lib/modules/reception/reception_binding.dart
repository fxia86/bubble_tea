import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:bubble_tea/data/services/special_service.dart';
import 'package:get/get.dart';

import 'reception_controller.dart';

class ReceptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => DishService());
    Get.lazyPut(() => SpecialDiscountService());
    Get.lazyPut(() => SpecialBundleService());
    Get.lazyPut(() => SpecialPriceService());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut(() => DishRepository());
    Get.lazyPut(() => SpecialDiscountRepository());
    Get.lazyPut(() => SpecialBundleRepository());
    Get.lazyPut(() => SpecialPriceRepository());
    Get.lazyPut<ReceptionController>(() => ReceptionController());
  }
}
