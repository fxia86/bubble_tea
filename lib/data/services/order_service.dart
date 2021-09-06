
import 'base.dart';

class OrderService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.ORDER, showLoading: showLoading);

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.ORDER, data: obj);

    return response;
  }
}