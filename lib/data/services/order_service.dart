import 'base.dart';

class OrderService {
  getAll({bool showLoading = true, String? date, String? shopId}) async {
    var response = await http.get(ServiceUrl.ORDER,
        showLoading: showLoading, params: {"shopId": shopId, "date": date});

    return response;
  }

  getStatistic({bool showLoading = true, String? date, String? shopId}) async {
    var response = await http.get("${ServiceUrl.ORDER}/statistic",
        showLoading: showLoading, params: {"shopId": shopId, "date": date});

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.ORDER, data: obj);

    return response;
  }
}
