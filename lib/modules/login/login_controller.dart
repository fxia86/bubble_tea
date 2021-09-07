import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/data/repositories/auth_repository.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository repository = Get.find();

  String email = "";
  String password = "";
  String verifyCode = "";
  var forgot = false.obs;
  var sended = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (LocalStorage.hasData("authUser")) {
      final user = LocalStorage.getAuthUser();
      goto(user.role);
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (LocalStorage.hasData("authUser")) {
      final user = LocalStorage.getAuthUser();
      goto(user.role);
    }
  }

  void onEmailChanged(String value) {
    email = value.trim();
  }

  void onPasswordChanged(String value) {
    password = value.trim();
  }

  void onLogin() async {
    if (!email.isEmail) {
      MessageBox.error('Invalid email');
    } else if (password.isEmpty) {
      MessageBox.error("Invalid password");
    } else {
      var user = await repository.login(email, password);
      goto(user.role);
    }
  }

  void goto(int? role) {
    switch (role) {
      case 1:
        Get.offAllNamed(Routes.MERCHANT);
        break;
      case 2:
        Get.offAllNamed(Routes.MANAGE_SHOP);
        break;
      case 4:
        Get.offAllNamed(Routes.RECEPTION);
        break;
      default:
    }
  }

  void onSend() async {
    if (!email.isEmail) {
      MessageBox.error('Invalid email');
    } else {
      //send verifycode
      await repository.verifycode(email);

      sended(true);

      MessageBox.success("The verification code has been sent",
          "If you do not receive the email, try again after 120 seconds");

      // 2分钟后可以再发
      Future.delayed(Duration(minutes: 2)).then((value) {
        sended(false);
      });
    }
  }

  void onCodeChanged(String value) {
    verifyCode = value.trim();
  }

  void onModifyLogin() async {
    if (!email.isEmail) {
      MessageBox.error('Invalid email');
    } else if (verifyCode.length != 6) {
      MessageBox.error("Invalid verify code");
    } else if (password.isEmpty) {
      MessageBox.error("Invalid password");
    } else {
      var user = await repository.verifylogin(email, password, verifyCode);
      goto(user.role);
    }
  }
}
