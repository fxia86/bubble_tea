import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:bubble_tea/data/services/special_service.dart';
import 'package:bubble_tea/modules/manage/special/bundle/bundle_controller.dart';
import 'package:bubble_tea/modules/manage/special/discount/discount_controller.dart';
import 'package:bubble_tea/modules/manage/special/price/price_controller.dart';
import 'package:get/get.dart';

import 'special_manage_controller.dart';

class SpecialManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => DishService());
    Get.lazyPut(() => SpecialDiscountService());
    Get.lazyPut(() => SpecialPriceService());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut(() => DishRepository());
    Get.lazyPut(() => SpecialDiscountRepository());
    Get.lazyPut(() => SpecialPriceRepository());
    Get.lazyPut<SpecialManageController>(() => SpecialManageController());
    Get.lazyPut<DiscountController>(() => DiscountController());
    Get.lazyPut<PriceController>(() => PriceController());
    Get.lazyPut<BundleController>(() => BundleController());
  }
}
