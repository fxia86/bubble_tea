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

  var category = 1.obs;

  var catalogs = <CatalogModel>[];
  var dishes = <DishModel>[];

  var discounts = <SpecialDiscountModel>[].obs;
  var prices = <SpecialPriceModel>[].obs;

  @override
  void onReady() async {
    super.onReady();

    catalogs = await Get.find<CatalogRepository>().getAll();
    dishes = await Get.find<DishRepository>().getAll();

    discounts.value = await discountRepository.getAll();
    prices.value = await priceRepository.getAll();
  }

  void deleteConfirm(String? id) {
    final item = discounts.singleWhere((element) => element.id == id);
    ConfirmBox.show("${item.dishName} - ${item.discount}%", () => delete(id));
  }

  void delete(String? id) async {
    final idx = discounts.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await discountRepository.delete(id);
      if (result) {
        discounts.removeAt(idx);
      }
    }
  }
}
