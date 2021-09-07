import 'package:bubble_tea/data/models/merchant_model.dart';
import 'package:bubble_tea/data/services/merchant_service.dart';
import 'package:get/get.dart';

class MerchantRepository {
  final MerchantService service = Get.find<MerchantService>();

  Future<List<MerchantModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => MerchantModel.fromJson(v)).toList();
    return items;
  }

  Future<MerchantModel> add(MerchantModel model) async {
    var data = await service.add(model);
    return MerchantModel.fromJson(data);
  }

  Future<bool> edit(MerchantModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
