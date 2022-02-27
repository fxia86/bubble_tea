import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/order_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:get/get.dart';

class ReportManageController extends GetxController {
  final OrderRepository repository = Get.find();

  var shops = <ShopModel>[];
  var statisticItems = <OrderStatisticModel>[];
  var items = <OrderModel>[].obs;
  var shopId = "".obs;
  var shopName = "All".obs;
  var beginDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedRowIndex = "".obs;
  var catalogs = <CatalogModel>[];
  var titles = ['Date'].obs;
  var rows = [].obs;
  var showDetail = false.obs;

  @override
  void onReady() async {
    super.onReady();

    shops = await Get.find<ShopRepository>().getAll();
    catalogs = await Get.find<CatalogRepository>().getAll();

    titles.value = [
      'Date',
      'Shop',
      ...catalogs.map((e) => e.name!),
      'Cash',
      'Card',
      'Total'
    ];

    await getData();
  }

  getData() async {
    rows.value = [];
    statisticItems = await repository.getStatistic(
        beginDate: beginDate.toString(),
        endDate: endDate.toString(),
        shopId: shopId.value);
    statisticItems.forEach((element) {
      var row = rows.firstWhere(
        (r) => r["date"] == element.date && r["shop"] == element.shop,
        orElse: () => {
          "date": element.date,
          "shop": element.shop,
          "cash": 0,
          "card": 0,
          "total": 0,
        },
      );
      rows.remove(row);
      row[element.catalogName] = element.totalAmount;
      row["card"] += element.cardAmount;
      row["total"] += element.totalAmount;
      row["cash"] = row["total"] - row["card"];
      rows.add(row);
    });
  }

  getDetail(date, shop) async {
    items.value = await repository.getAll(
        date: date,
        shopId: shops.firstWhere((element) => element.name == shop).id);
  }
}
