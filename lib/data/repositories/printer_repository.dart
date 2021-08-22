import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/services/printer_service.dart';
import 'package:get/get.dart';


class PrinterRepository {
    final PrinterService service = Get.find<PrinterService>();

  Future<List<PrinterModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items = List.castFrom(data).map((v) => PrinterModel.fromJson(v)).toList();
    return items;
  }

  Future<PrinterModel> add(PrinterModel model) async {
    var data = await service.add(model);
    return PrinterModel.fromJson(data);
  }

  Future<bool> edit(PrinterModel model) async {
    return await service.edit(model);
  }

  Future<bool> delete(String? id) async {
    return await service.delete(id);
  }
}
