import 'base.dart';

class OrderService {
  getAll({bool showLoading = true, String? date, String? shopId}) async {
    var response = await http.get(ServiceUrl.ORDER,
        showLoading: showLoading, params: {"shopId": shopId, "date": date});

    return response;
  }

  getStatistic(
      {bool showLoading = true,
      String? beginDate,
      String? endDate,
      String? shopId}) async {
    var response = await http.get("${ServiceUrl.ORDER}/statistic",
        showLoading: showLoading,
        params: {"shopId": shopId, "beginDate": beginDate, "endDate": endDate});

    return response;
  }

  getLineStatistic({
    bool showLoading = true,
    String? date,
  }) async {
    var response = await http.get("${ServiceUrl.ORDER}/line-statistic",
        showLoading: showLoading, params: {"date": date});

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.ORDER, data: obj);

    return response;
  }
}
