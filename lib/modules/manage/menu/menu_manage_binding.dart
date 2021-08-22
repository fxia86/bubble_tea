import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:bubble_tea/data/services/material_service.dart';
import 'package:get/get.dart';

import 'menu_manage_controller.dart';

class MenuManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaterialService());
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => DishService());
    Get.lazyPut(() => MaterialRepository());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut(() => DishRepository());
    Get.lazyPut<MenuManageController>(() => MenuManageController());
  }
}
