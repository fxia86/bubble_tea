import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:get/get.dart';

class BundleController extends GetxController {
  final SpecialDiscountRepository discountRepository = Get.find();

  var category = 1.obs;

  var discounts = <SpecialDiscountModel>[].obs;
  var editItem = SpecialDiscountModel().obs;

  @override
  void onReady() async {
    super.onReady();

    discounts.value = await discountRepository.getAll();
  }

  void deleteConfirm(String? id) {
    final item = discounts.singleWhere((element) => element.id == id);
    ConfirmBox.show(item.dishName, () => delete(id));
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

  // void save() async {
  //   if (editItem.value.name == null || editItem.value.name!.isEmpty) {
  //     MessageBox.error('Invalid name');
  //   } else if (editItem.value.email == null ||
  //       editItem.value.email!.isEmpty ||
  //       !GetUtils.isEmail(editItem.value.email!)) {
  //     MessageBox.error('Invalid email');
  //   } else if (editItem.value.phone == null ||
  //       editItem.value.phone!.isEmpty ||
  //       !GetUtils.isPhoneNumber(editItem.value.phone!)) {
  //     MessageBox.error('Invalid phone');
  //   } else {
  //     final idx = items.indexWhere((element) =>
  //         element.name == editItem.value.name &&
  //         element.id != editItem.value.id);
  //     if (idx > -1) {
  //       MessageBox.error('Duplicated Name');
  //       return;
  //     }
  //     if (isNew.value) {
  //       var item = await repository.add(editItem.value);
  //       items.insert(0, item);
  //     } else {
  //       var item =
  //           items.singleWhere((element) => element.id == editItem.value.id);
  //       if (item.name == editItem.value.name &&
  //           item.email == editItem.value.email &&
  //           item.phone == editItem.value.phone) {
  //         showForm.value = false;
  //         return;
  //       }
  //       var result = await repository.edit(editItem.value);
  //       if (result) {
  //         item
  //           ..name = editItem.value.name
  //           ..email = editItem.value.email
  //           ..phone = editItem.value.phone;
  //         items.refresh();
  //       }
  //     }
  //     showForm.value = false;
  //   }
  // }
}