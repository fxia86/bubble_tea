import 'package:bubble_tea/data/services/base.dart';

class MaterialService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.Material, showLoading: showLoading);

    return response;
  }

  add(obj) async {
    var response = await http.postForm(ServiceUrl.Material, params: obj);

    return response;
  }

  edit(obj) async {
    var response =
        await http.putForm('${ServiceUrl.Material}/${obj["id"]}', params: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.Material}/$id');

    return response;
  }

  getStocks(String? id, {bool showLoading = true}) async {
    var response =
        await http.get('${ServiceUrl.Material}/$id/stock', showLoading: showLoading);

    return response;
  }

  getStockOrders(String? id, {bool showLoading = true}) async {
    var response =
        await http.get('${ServiceUrl.Material}/$id/stockorder', showLoading: showLoading);

    return response;
  }

  addOrder(obj) async {
    var response = await http.post('${ServiceUrl.Material}/${obj.materialId}/stockorder', data: obj);

    return response;
  }
}
