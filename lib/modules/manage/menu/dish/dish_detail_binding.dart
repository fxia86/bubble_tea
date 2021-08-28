import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:get/get.dart';

import 'dish_detail_controller.dart';

class DishDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DishService());
    Get.lazyPut(() => DishRepository());
    Get.lazyPut<DishDetailController>(() => DishDetailController());
  }
}
