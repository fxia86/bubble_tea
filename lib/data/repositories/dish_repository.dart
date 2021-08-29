import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/services/dish_service.dart';
import 'package:get/get.dart';

class DishRepository {
  final DishService service = Get.find<DishService>();

  Future<List<DishModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => DishModel.fromJson(v)).toList();
    return items;
  }

  Future<DishModel> add(Map<dynamic, dynamic> model) async {
    var data = await service.add(model);
    return DishModel.fromJson(data);
  }

  Future<DishModel> edit(Map<dynamic, dynamic> model) async {
    var data = await service.edit(model);
    return DishModel.fromJson(data);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }

  Future<bool> reorder(String? id, int oldIndex, int newIndex,{bool showLoading = true}) async {
    return await service.reorder(id, oldIndex, newIndex,showLoading: showLoading);
  }

  Future<bool> saveDishMaterials(
      String? id, List<DishMaterialModel> dishMaterials) async {
    return await service.saveDishMaterials(id, dishMaterials);
  }

  Future<bool> saveDishPrinters(
      String? id, List<DishPrinterModel> dishPrinters) async {
    return await service.saveDishPrinters(id, dishPrinters);
  }

  Future<bool> saveDishOptions(
      String? id, List<DishOptionModel> dishOptions) async {
    return await service.saveDishOptions(id, dishOptions);
  }
}
