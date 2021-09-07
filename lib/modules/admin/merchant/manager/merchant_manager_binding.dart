import 'package:bubble_tea/data/repositories/user_repository.dart';
import 'package:bubble_tea/data/services/user_service.dart';
import 'package:bubble_tea/modules/admin/merchant/manager/merchant_manager_controller.dart';
import 'package:get/get.dart';

class MerchantManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserService());
    Get.lazyPut(() => UserRepository());
    Get.lazyPut<MerchantManagerController>(() => MerchantManagerController());
  }
}
