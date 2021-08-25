import 'package:bubble_tea/data/services/base.dart';

class AdditionService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.ADDITION, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.ADDITION, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.ADDITION}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.ADDITION}/$id');

    return response;
  }

  addOption(obj) async {
    var response = await http.post(ServiceUrl.ADDITION_OPTION, data: obj);

    return response;
  }

  editOption(obj) async {
    var response = await http.put('${ServiceUrl.ADDITION_OPTION}/${obj.id}', data: obj);

    return response;
  }

  deleteOption(id) async {
    var response = await http.delete('${ServiceUrl.ADDITION_OPTION}/$id');

    return response;
  }
}
