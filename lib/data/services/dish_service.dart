import 'package:bubble_tea/data/services/base.dart';

class DishService {
  getAll({bool showLoading = true}) async {
    var response = await http.get(ServiceUrl.DISH, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.postForm(ServiceUrl.DISH, params: obj);

    return response;
  }

  edit(obj) async {
    var response =
        await http.putForm('${ServiceUrl.DISH}/${obj["id"]}', params: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.DISH}/$id');

    return response;
  }

  reorder(id, oldIndex, newIndex, {bool showLoading = true}) async {
    var response = await http.get('${ServiceUrl.DISH}/reorder',
        showLoading: showLoading,
        params: {"id": id, "oldIndex": oldIndex, "newIndex": newIndex});

    return response;
  }

  saveDishMaterials(id, dishMaterials) async {
    var response =
        await http.post('${ServiceUrl.DISH}/$id/material', data: dishMaterials);

    return response;
  }

  saveDishPrinters(id, dishPrinters) async {
    var response =
        await http.post('${ServiceUrl.DISH}/$id/printer', data: dishPrinters);

    return response;
  }
  
  saveDishOptions(id, dishOptions) async {
    var response =
        await http.post('${ServiceUrl.DISH}/$id/option', data: dishOptions);

    return response;
  }
}
