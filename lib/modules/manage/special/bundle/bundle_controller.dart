import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../special_manage_controller.dart';

class BundleController extends GetxController {
  final SpecialBundleRepository repository =
      Get.find<SpecialBundleRepository>();
  final SpecialManageController _parent = Get.find<SpecialManageController>();

  var catalogId = "".obs;
  var id = "".obs;
  var offerPrice = 0.obs;
  var dishes = <BundleDishModel>[].obs;
  var total = 0.obs;
  var availableDishes = <DishModel>[].obs;

  FocusNode qtyFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is SpecialBundleModel) {
      id(Get.arguments.id);
      offerPrice(Get.arguments.offerPrice);
      dishes(Get.arguments.dishes);
      calculateTotal();
    }

    qtyFocusNode.addListener(() {
      if (qtyFocusNode.hasFocus) {
      } else {
        for (var item in dishes) {
          item.selected = false;
        }
        dishes.refresh();
      }
    });
  }

  calculateTotal() {
    var sum = 0;
    for (var item in dishes) {
      final price = _parent.dishes
          .firstWhere((element) => element.id == item.dishId)
          .price;
      sum += item.qty! * price!;
    }
    total(sum);
  }

  selectCatalog(String? id) {
    catalogId(id);
    availableDishes.value =
        _parent.dishes.where((element) => element.catalogId == id).toList();
  }

  addDish(DishModel v) {
    var item = dishes.singleWhere(
      (element) => element.dishId == v.id,
      orElse: () {
        var item = BundleDishModel(
          dishId: v.id,
          dishName: v.name,
          qty: 0,
        );
        dishes.add(item);
        return item;
      },
    );

    item.qty = item.qty! + 1;
    dishes.refresh();
    calculateTotal();
  }

  void save() async {
    if (dishes.isEmpty) {
      MessageBox.error('No item selected');
    } else if (offerPrice < 1) {
      MessageBox.error('Invalid offer price');
    } else {
      var item = SpecialBundleModel(
        id: id.value,
        offerPrice: offerPrice.value,
      )..dishes = List.from(dishes);
      final result = await repository.save(item.toJson());
      id(item.id);
      item.id = result.id;

      final idx =
          _parent.bundles.indexWhere((element) => element.id == result.id);
      if (idx > -1) {
        _parent.bundles[idx] = item..id = result.id;
      } else {
        _parent.bundles.add(item..id = result.id);
      }
      _parent.bundles.sort((a, b) => b.offerPrice!.compareTo(a.offerPrice!));
      MessageBox.success();
    }
  }
}
