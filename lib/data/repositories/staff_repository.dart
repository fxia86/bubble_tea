import 'package:bubble_tea/data/models/staff_model.dart';
import 'package:bubble_tea/data/services/staff_service.dart';
import 'package:get/get.dart';


class StaffRepository {
  final StaffService service = Get.find<StaffService>();

  Future<List<StaffModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => StaffModel.fromJson(v)).toList();
    return items;
  }

  Future<StaffModel> add(StaffModel model) async {
    var data = await service.add(model);
    return StaffModel.fromJson(data);
  }

  Future<bool> edit(StaffModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
