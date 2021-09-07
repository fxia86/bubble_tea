import 'package:bubble_tea/data/models/auth/auth_user.dart';
import 'package:bubble_tea/data/services/auth_service.dart';
import 'package:bubble_tea/utils/common_utils.dart';
import 'package:get/get.dart';

class AuthRepository {
  final AuthService service = Get.find<AuthService>();

  Future<AuthUserModel> login(String email, String password) async {
    var data = await service.login(email, CommonUtils.md5Crypto(password));
    var user = AuthUserModel.fromJson(data["user"]);
    return user;
  }

  Future<bool> modify(String originPwd, String newPwd) async {
    return await service.modify(
        CommonUtils.md5Crypto(originPwd), CommonUtils.md5Crypto(newPwd));
  }

  Future<Null> verifycode(String email) async {
    return await service.verifycode(email);
  }

  Future<AuthUserModel> verifylogin(
      String email, String password, String verifyCode) async {
    var data = await service.verifylogin(
        email, CommonUtils.md5Crypto(password), verifyCode);
    var user = AuthUserModel.fromJson(data["user"]);
    return user;
  }
}
