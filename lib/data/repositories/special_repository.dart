import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/services/special_service.dart';
import 'package:get/get.dart';

class SpecialDiscountRepository {
  final SpecialDiscountService service = Get.find<SpecialDiscountService>();

  Future<List<SpecialDiscountModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data)
        .map((v) => SpecialDiscountModel.fromJson(v))
        .toList();
    return items;
  }

  Future<SpecialDiscountModel> save(SpecialDiscountModel model) async {
    var data = await service.save(model);
    return SpecialDiscountModel.fromJson(data);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}

class SpecialPriceRepository {
  final SpecialPriceService service = Get.find<SpecialPriceService>();

  Future<List<SpecialPriceModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => SpecialPriceModel.fromJson(v)).toList();
    return items;
  }

  Future<SpecialPriceModel> save(SpecialPriceModel model) async {
    var data = await service.save(model);
    return SpecialPriceModel.fromJson(data);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
