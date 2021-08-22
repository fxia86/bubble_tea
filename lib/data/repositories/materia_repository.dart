import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/services/material_service.dart';
import 'package:get/get.dart';

class MaterialRepository {
  final MaterialService service = Get.find<MaterialService>();

  Future<List<MaterialModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => MaterialModel.fromJson(v)).toList();
    return items;
  }

  Future<MaterialModel> add(Map<dynamic, dynamic> model) async {
    var data = await service.add(model);
    return MaterialModel.fromJson(data);
  }

  Future<MaterialModel> edit(Map<dynamic, dynamic> model) async {
    var data = await service.edit(model);
    return MaterialModel.fromJson(data);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }

  Future<List<MaterialStockModel>> getStocks(String? id,
      {bool showLoading = true}) async {
    var data = await service.getStocks(id, showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => MaterialStockModel.fromJson(v)).toList();
    return items;
  }

  Future<List<MaterialStockOrderModel>> getStockOrders(String? id,
      {bool showLoading = true}) async {
    var data = await service.getStockOrders(id, showLoading: showLoading);
    var items = List.castFrom(data)
        .map((v) => MaterialStockOrderModel.fromJson(v))
        .toList();
    return items;
  }

  Future<bool> addOrder(MaterialStockOrderModel model) async {
    return await service.addOrder(model);
  }
}
