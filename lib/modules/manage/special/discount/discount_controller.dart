import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

import '../special_manage_controller.dart';

class DiscountController extends GetxController {
  final SpecialDiscountRepository repository =
      Get.find<SpecialDiscountRepository>();
  final SpecialManageController _parent = Get.find<SpecialManageController>();

  var catalogId = "".obs;
  var dishId = "".obs;
  var dishName = "".obs;
  var discount = 0.obs;

  @override
  void onReady() async {
    super.onReady();

    if (Get.arguments is SpecialDiscountModel) {
      dishId(Get.arguments.dishId);
      dishName(Get.arguments.dishName);
      discount(Get.arguments.discount);
      final dish = _parent.dishes
          .firstWhere((element) => element.id == Get.arguments.dishId);
      catalogId(dish.catalogId);
    }
  }

  void save() async {
    if (dishId.isEmpty) {
      MessageBox.error('No item selected');
    } else if (discount < 1 || discount > 99) {
      MessageBox.error('Invalid discount');
    } else {
      final result = await repository.save(SpecialDiscountModel(
        dishId: dishId.value,
        dishName: dishName.value,
        discount: discount.value,
      ))
        ..dishName = dishName.value;

      final idx =
          _parent.discounts.indexWhere((element) => element.id == result.id);
      if (idx > -1) {
        _parent.discounts[idx] = result;
      } else {
        _parent.discounts.add(result);
      }
      _parent.discounts.sort((a, b) => b.discount!.compareTo(a.discount!));
      MessageBox.success();
    }
  }
}
