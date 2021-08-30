import 'package:bubble_tea/data/services/base.dart';

class SpecialDiscountService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.SPECIAL_DISCOUNT, showLoading: showLoading);

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.SPECIAL_DISCOUNT, data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.SPECIAL_DISCOUNT}/$id');

    return response;
  }
}

class SpecialBundleService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.SPECIAL_BUNDLE, showLoading: showLoading);

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.SPECIAL_BUNDLE, data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.SPECIAL_BUNDLE}/$id');

    return response;
  }
}

class SpecialPriceService {
  getAll({bool showLoading = true}) async {
    var response =
        await http.get(ServiceUrl.SPECIAL_PRICE, showLoading: showLoading);

    return response;
  }

  save(obj) async {
    var response = await http.post(ServiceUrl.SPECIAL_PRICE, data: obj);

    return response;
  }

  delete(id) async {
    var response = await http.delete('${ServiceUrl.SPECIAL_PRICE}/$id');

    return response;
  }
}
