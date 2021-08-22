import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/services/shop_service.dart';
import 'package:get/get.dart';

class ShopRepository {
  final ShopService service = Get.find<ShopService>();

  Future<List<ShopModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => ShopModel.fromJson(v)).toList();
    return items;
  }

  Future<ShopModel> add(ShopModel model) async {
    var data = await service.add(model);
    return ShopModel.fromJson(data);
  }

  Future<bool> edit(ShopModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
