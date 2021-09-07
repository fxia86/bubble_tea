import 'package:bubble_tea/data/models/user_model.dart';
import 'package:bubble_tea/data/services/user_service.dart';
import 'package:get/get.dart';

class UserRepository {
  final UserService service = Get.find<UserService>();

  Future<List<UserModel>> getStaffs({bool showLoading = true}) async {
    var data = await service.getStaffs(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => UserModel.fromJson(v)).toList();
    return items;
  }

  Future<List<UserModel>> getManagers(
      {bool showLoading = true, String? merchantId}) async {
    var data = await service.getManagers(
        showLoading: showLoading, merchantId: merchantId);
    var items = List.castFrom(data).map((v) => UserModel.fromJson(v)).toList();
    return items;
  }

  Future<UserModel> add(UserModel model) async {
    var data = await service.add(model);
    return UserModel.fromJson(data);
  }

  Future<bool> edit(UserModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
