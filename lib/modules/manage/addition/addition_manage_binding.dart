import 'package:bubble_tea/data/repositories/addition_repository.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/services/addition_service.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:bubble_tea/modules/manage/addition/addition_manage_controller.dart';
import 'package:get/get.dart';

class AdditionManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdditionService());
    Get.lazyPut(() => CatalogService());
    Get.lazyPut(() => AdditionRepository());
    Get.lazyPut(() => CatalogRepository());
    Get.lazyPut<AdditionManageController>(() => AdditionManageController());
  }
}
