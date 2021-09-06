import 'package:bubble_tea/data/services/base.dart';

class PrinterService {
  getAll({bool showLoading = true, String? shopId}) async {
    var response = await http.get(ServiceUrl.PRINTER,
        showLoading: showLoading, params: {"shopId": shopId});

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.PRINTER, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.PRINTER}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.PRINTER}/$id');

    return response;
  }
}
