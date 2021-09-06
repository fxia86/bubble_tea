
import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/services/order_service.dart';
import 'package:get/get.dart';

class OrderRepository {
  final OrderService service = Get.find<OrderService>();

  Future<List<OrderModel>> getAll({bool showLoading = true}) async {
    var data = await service.getAll(showLoading: showLoading);
    var items =
        List.castFrom(data).map((v) => OrderModel.fromJson(v)).toList();
    return items;
  }

  Future<OrderModel> save(Map<dynamic, dynamic> model) async {
    var data = await service.save(model);
    return OrderModel.fromJson(data);
  }
}