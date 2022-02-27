import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/services/order_service.dart';
import 'package:get/get.dart';

class OrderRepository {
  final OrderService service = Get.find<OrderService>();

  Future<List<OrderModel>> getAll(
      {bool showLoading = true, String? date, String? shopId}) async {
    var data = await service.getAll(
        showLoading: showLoading, date: date, shopId: shopId);
    var items = List.castFrom(data).map((v) => OrderModel.fromJson(v)).toList();
    return items;
  }

  Future<List<OrderStatisticModel>> getStatistic(
      {bool showLoading = true,
      String? beginDate,
      String? endDate,
      String? shopId}) async {
    var data = await service.getStatistic(
        showLoading: showLoading,
        beginDate: beginDate,
        endDate: endDate,
        shopId: shopId);
    var items = List.castFrom(data)
        .map((v) => OrderStatisticModel.fromJson(v))
        .toList();
    return items;
  }

  Future<OrderModel> save(Map<dynamic, dynamic> model) async {
    var data = await service.save(model);
    return OrderModel.fromJson(data);
  }
}
