import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:get/get.dart';


class DishRepository {
  final DishService service = Get.find<DishService>();

  Future<List<DishModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => DishModel.fromJson(v)).toList();
    return items;
  }

  Future<DishModel> add(DishModel model) async {
    var data = await service.add(model);
    return DishModel.fromJson(data);
  }

  Future<bool> edit(DishModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }

  Future<bool> reorder(String? id, int oldIndex, int newIndex) async {
    return await service.reorder(id, oldIndex, newIndex);
  }
}
