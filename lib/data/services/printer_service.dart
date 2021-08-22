import 'package:bubble_tea/data/services/base.dart';

class PrinterService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.SHOP, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.SHOP, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.SHOP}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.SHOP}/$id');

    return response;
  }
}
