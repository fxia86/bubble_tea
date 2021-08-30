import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

import '../special_manage_controller.dart';

class PriceController extends GetxController {
  final SpecialPriceRepository repository = Get.find<SpecialPriceRepository>();
  final SpecialManageController _parent = Get.find<SpecialManageController>();

  var catalogId = "".obs;
  var dishId = "".obs;
  var dishName = "".obs;
  var offerPrice = 0.obs;
  var originalPrice = 0.obs;
  var start = "".obs;
  var end = "".obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is SpecialPriceModel) {
      dishId(Get.arguments.dishId);
      dishName(Get.arguments.dishName);
      originalPrice(Get.arguments.originalPrice);
      offerPrice(Get.arguments.offerPrice);
      start(Get.arguments.start);
      end(Get.arguments.end);
      final dish = _parent.dishes
          .firstWhere((element) => element.id == Get.arguments.dishId);
      catalogId(dish.catalogId);
    }
  }

  void save() async {
    if (dishId.isEmpty) {
      MessageBox.error('No item selected');
    }else if (start.isEmpty||end.isEmpty ) {
      MessageBox.error('Please select available date');
    }  else if (offerPrice < 1 ) {
      MessageBox.error('Invalid offer price');
    } else {
      final result = await repository.save(SpecialPriceModel(
        dishId: dishId.value,
        offerPrice: offerPrice.value,
        start: start.value,
        end: end.value,
      ))
        ..dishName = dishName.value
        ..originalPrice = originalPrice.value;

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
