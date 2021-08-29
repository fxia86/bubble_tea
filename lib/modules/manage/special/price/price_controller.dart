import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

import '../special_manage_controller.dart';

class PriceController extends GetxController {
  final SpecialPriceRepository discountRepository = Get.find();

  final SpecialPriceRepository repository =
      Get.find<SpecialPriceRepository>();
  final SpecialManageController _parent = Get.find<SpecialManageController>();

  var catalogId = "".obs;
  var dishId = "".obs;
  var dishName = "".obs;
  var offerPrice = 0.obs;

  @override
  void onReady() async {
    super.onReady();

    if (Get.arguments is SpecialPriceModel) {
      dishId(Get.arguments.dishId);
      dishName(Get.arguments.dishName);
      offerPrice(Get.arguments.offerPrice);
      final dish = _parent.dishes
          .firstWhere((element) => element.id == Get.arguments.dishId);
      catalogId(dish.catalogId);
    }
  }

  void save() async {
    if (dishId.isEmpty) {
      MessageBox.error('No item selected');
    } else if (offerPrice < 1 || offerPrice > 99) {
      MessageBox.error('Invalid discount');
    } else {
      final result = await repository.save(SpecialPriceModel(
        dishId: dishId.value,
        dishName: dishName.value,
        offerPrice: offerPrice.value,
      ))
        ..dishName = dishName.value;

      final idx =
          _parent.prices.indexWhere((element) => element.id == result.id);
      if (idx > -1) {
        _parent.prices[idx] = result;
      } else {
        _parent.prices.add(result);
      }
      _parent.prices.sort((a, b) => b.offerPrice!.compareTo(a.offerPrice!));
      MessageBox.success();
    }
  }
}
