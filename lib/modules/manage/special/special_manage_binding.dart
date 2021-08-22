import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:get/get.dart';

import 'special_manage_controller.dart';

class SpecialManageBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SpecialManageApi());
    Get.lazyPut(() => SpecialRepository());
    Get.lazyPut<SpecialManageController>(() => SpecialManageController());
  }
}
