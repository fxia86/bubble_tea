import 'package:bubble_tea/data/services/base.dart';

class UserService {
  getStaffs({bool showLoading = true}) async {
    var response =
        await http.get("${ServiceUrl.USER}/staff", showLoading: showLoading);

    return response;
  }

  getManagers({bool showLoading = true, String? merchantId}) async {
    var response = await http.get("${ServiceUrl.USER}/manager",
        showLoading: showLoading, params: {"merchantId": merchantId});

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.USER, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.USER}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.USER}/$id');

    return response;
  }
}
