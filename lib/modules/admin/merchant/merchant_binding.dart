import 'package:bubble_tea/data/repositories/merchant_repository.dart';
import 'package:bubble_tea/data/services/merchant_service.dart';
import 'package:get/get.dart';

import 'merchant_controller.dart';

class MerchantBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MerchantService());
    Get.lazyPut(() => MerchantRepository());
    Get.lazyPut<MerchantController>(() => MerchantController());
  }
}
