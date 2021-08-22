import 'package:bubble_tea/data/models/supplier_model.dart';
import 'package:bubble_tea/data/services/supplier_service.dart';
import 'package:get/get.dart';

class SupplierRepository {
  final SupplierService service = Get.find<SupplierService>();

  Future<List<SupplierModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => SupplierModel.fromJson(v)).toList();
    return items;
  }

  Future<SupplierModel> add(SupplierModel model) async {
    var data = await service.add(model);
    return SupplierModel.fromJson(data);
  }

  Future<bool> edit(SupplierModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
