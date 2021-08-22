import 'package:bubble_tea/data/services/base.dart';

class StaffService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.STAFF, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.STAFF, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.STAFF}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.STAFF}/$id');

    return response;
  }
}
