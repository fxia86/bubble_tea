import 'package:bubble_tea/data/services/base.dart';

class SupplierService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.SUPPLIER, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.SUPPLIER, data: obj);

    return response;
  }

  edit(obj) async {
    var response =
        await http.put('${ServiceUrl.SUPPLIER}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.SUPPLIER}/$id');

    return response;
  }
}
