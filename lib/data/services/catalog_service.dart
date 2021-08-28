import 'package:bubble_tea/data/services/base.dart';

class CatalogService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.CATALOG, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.post(ServiceUrl.CATALOG, data: obj);

    return response;
  }

  edit(obj) async {
    var response = await http.put('${ServiceUrl.CATALOG}/${obj.id}', data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.CATALOG}/$id');

    return response;
  }

  reorder(id, oldIndex, newIndex, {bool showLoading = true}) async {
    var response = await http.get('${ServiceUrl.CATALOG}/reorder',
        showLoading: showLoading,
        params: {"id": id, "oldIndex": oldIndex, "newIndex": newIndex});

    return response;
  }
}
