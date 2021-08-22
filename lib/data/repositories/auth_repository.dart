import 'package:bubble_tea/data/models/auth/auth_user.dart';
import 'package:bubble_tea/data/services/auth_service.dart';
import 'package:get/get.dart';

class AuthRepository {
  final AuthService service = Get.find<AuthService>();

  Future<AuthUserModel> login(String email, String password) async {
    var data = await service.login(email, password);
    var user = AuthUserModel.fromJson(data["user"]);
    return user;
  }
}
