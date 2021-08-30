import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:get/get.dart';

class SpecialManageController extends GetxController {
  final discountRepository = Get.find<SpecialDiscountRepository>();
  final priceRepository = Get.find<SpecialPriceRepository>();
  final bundleRepository = Get.find<SpecialBundleRepository>();

  var category = 1.obs;

  var catalogs = <CatalogModel>[];
  var dishes = <DishModel>[];

  var discounts = <SpecialDiscountModel>[].obs;
  var bundles = <SpecialBundleModel>[].obs;
  var prices = <SpecialPriceModel>[].obs;

  @override
  void onReady() async {
    super.onReady();

    catalogs = await Get.find<CatalogRepository>().getAll();
    dishes = await Get.find<DishRepository>().getAll();

    discounts.value = await discountRepository.getAll();
    prices.value = await priceRepository.getAll();
    bundles.value = await bundleRepository.getAll();
  }

  void deleteConfirm(String? id) {
    switch (category.value) {
      case 1:
        final item = discounts.singleWhere((element) => element.id == id);
        ConfirmBox.show(
            "${item.dishName} - ${item.discount}%", () => deleteDiscount(id));
        break;
      case 2:
        final item = bundles.singleWhere((element) => element.id == id);
        final dishes = item.dishes.map((e) => e.dishName).join(", ");
        ConfirmBox.show(
            "$dishes - €${(item.offerPrice! / 100).toStringAsFixed(2)}", () => deleteBundle(id));
        break;
      case 3:
        final item = prices.singleWhere((element) => element.id == id);
        ConfirmBox.show("${item.dishName} - €${(item.offerPrice! / 100).toStringAsFixed(2)}", () => deletePrice(id));
        break;
      default:
        break;
    }
  }

  void deleteDiscount(String? id) async {
    final idx = discounts.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await discountRepository.delete(id);
      if (result) {
        discounts.removeAt(idx);
      }
    }
  }

  void deleteBundle(String? id) async {
    final idx = bundles.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await bundleRepository.delete(id);
      if (result) {
        bundles.removeAt(idx);
      }
    }
  }

  void deletePrice(String? id) async {
    final idx = prices.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await priceRepository.delete(id);
      if (result) {
        prices.removeAt(idx);
      }
    }
  }
}
