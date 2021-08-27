import 'package:bubble_tea/data/repositories/addition_repository.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/data/services/addition_service.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:bubble_tea/data/services/material_service.dart';
import 'package:bubble_tea/data/services/printer_service.dart';
import 'package:get/get.dart';

import 'dish_detail_controller.dart';

class DishDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaterialService());
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => PrinterService());
    Get.lazyPut(() => DishService());
    Get.lazyPut(() => AdditionService());
    Get.lazyPut(() => MaterialRepository());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut(() => PrinterRepository());
    Get.lazyPut(() => DishRepository());
    Get.lazyPut(() => AdditionRepository());
    Get.lazyPut<DishDetailController>(() => DishDetailController());
  }
}
