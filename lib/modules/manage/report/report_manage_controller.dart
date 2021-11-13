import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/order_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:get/get.dart';

class ReportManageController extends GetxController {
  final OrderRepository repository = Get.find();

  var shops = <ShopModel>[].obs;
  var statisticItems = <OrderStatisticModel>[].obs;
  var items = <OrderModel>[].obs;
  var shopId = "".obs;
  var shopName = "All".obs;
  var date = DateTime.now().obs;

  @override
  void onReady() async {
    super.onReady();

    await getData();
    shops.value = await Get.find<ShopRepository>().getAll();
    shops.insert(0, new ShopModel(name: "All")..id = "");
  }

  getData() async {
    statisticItems.value = await repository.getStatistic(
        date: date.toString(), shopId: shopId.value);
    if (statisticItems.length > 0) {
      var cardAmount = 0;
      var totalAmount = 0;
      for (var item in statisticItems) {
        cardAmount += item.cardAmount!;
        totalAmount += item.totalAmount!;
      }
      statisticItems.add(OrderStatisticModel(
        catalogName: "TOTAL",
        cashAmount: totalAmount - cardAmount,
        cardAmount: cardAmount,
        totalAmount: totalAmount,
      ));
    }

    items.value =
        await repository.getAll(date: date.toString(), shopId: shopId.value);
  }

  void selectShop(ShopModel item) {
    shopId(item.id);
    shopName(item.name);
    getData();
  }
}
