import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/services/catalog_service.dart';
import 'package:get/get.dart';

class CatalogRepository {
  final CatalogService service = Get.find<CatalogService>();

  Future<List<CatalogModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => CatalogModel.fromJson(v)).toList();
    return items;
  }

  Future<CatalogModel> add(CatalogModel model) async {
    var data = await service.add(model);
    return CatalogModel.fromJson(data);
  }

  Future<bool> edit(CatalogModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }

  Future<bool> reorder(String? id, int oldIndex, int newIndex,
      {bool showLoading = true}) async {
    return await service.reorder(id, oldIndex, newIndex,
        showLoading: showLoading);
  }
}
