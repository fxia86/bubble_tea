import 'package:bubble_tea/data/services/base.dart';

class MerchantService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.MERCHANT, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.MERCHANT, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.MERCHANT}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.MERCHANT}/$id');

    return response;
  }
}
