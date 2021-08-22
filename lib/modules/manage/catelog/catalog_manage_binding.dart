import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';

import 'catalog_manage_controller.dart';
import 'package:get/get.dart';

class CatalogManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut<CatalogManageController>(() => CatalogManageController());
  }
}
