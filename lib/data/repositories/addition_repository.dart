import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/services/addition_service.dart';
import 'package:get/get.dart';

class AdditionRepository {
  final AdditionService service = Get.find<AdditionService>();

  Future<List<AdditionModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => AdditionModel.fromJson(v)).toList();
    return items;
  }

  Future<AdditionModel> add(AdditionModel model) async {
    var data = await service.add(model);
    return AdditionModel.fromJson(data);
  }

  Future<bool> edit(AdditionModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }

  Future<AdditionOptionModel> addOption(AdditionOptionModel model) async {
    var data = await service.addOption(model);
    return AdditionOptionModel.fromJson(data);
  }

  Future<bool> editOption(AdditionOptionModel model) async {
    return await service.editOption(model);
  }

  Future<bool> deleteOption(String? id) async {
    return await service.deleteOption(id);
  }
}
