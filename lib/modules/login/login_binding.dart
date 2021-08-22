import 'package:bubble_tea/data/services/auth_service.dart';
import 'package:bubble_tea/data/repositories/auth_repository.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
