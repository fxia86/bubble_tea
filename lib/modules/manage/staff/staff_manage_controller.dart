import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/models/staff_model.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/repositories/staff_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class StaffManageController extends GetxController {
  final StaffRepository repository = Get.find();
  var showForm = false.obs;
  var isNew = true.obs;

  var shops = <ShopModel>[];
  var items = <StaffModel>[].obs;
  var editItem = StaffModel().obs;
  var keywords = "".obs;

  @override
  void onReady() async {
    super.onReady();

    items.value = await repository.getAll();
    shops = await Get.find<ShopRepository>().getAll();
  }

  void add() {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = true;
      editItem.value = StaffModel();
    }
  }

  void edit(String? id) {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = false;
      var item = items.singleWhere((element) => element.id == id);
      editItem.value = StaffModel(
          name: item.name,
          email: item.email,
          phone: item.phone,
          shopId: item.shopId,
          shopName: item.shopName);
      editItem.value.id = item.id;
    }
  }

  void deleteConfirm(String? id) {
    final item = items.singleWhere((element) => element.id == id);
    ConfirmBox.show(item.name, () => delete(id));
  }

  void delete(String? id) async {
    if (showForm.value) {
      showForm.value = false;
    }

    final idx = items.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await repository.delete(id);
      if (result) {
        items.removeAt(idx);
      }
    }
  }

  void selectShop(ShopModel item) {
    editItem.value.shopId = item.id;
    editItem.value.shopName = item.name;
    editItem.refresh();
  }

  void save() async {
    if (editItem.value.shopId == null || editItem.value.shopId!.isEmpty) {
      MessageBox.error('Please select a shop');
    } else if (editItem.value.name == null || editItem.value.name!.isEmpty) {
      MessageBox.error('Invalid name');
    } else if (editItem.value.email == null ||
        editItem.value.email!.isEmpty ||
        !editItem.value.email!.isEmail) {
      MessageBox.error('Invalid email');
    } else if (editItem.value.phone == null ||
        editItem.value.phone!.isEmpty ||
        !editItem.value.phone!.isPhoneNumber) {
      MessageBox.error('Invalid phone');
    } else {
      final idx = items.indexWhere((element) =>
          element.name == editItem.value.name &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      if (isNew.value) {
        var item = await repository.add(editItem.value);
        item.shopName = editItem.value.shopName;
        items.insert(0, item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);
        if (item.shopId == editItem.value.shopId &&
            item.name == editItem.value.name &&
            item.email == editItem.value.email &&
            item.phone == editItem.value.phone) {
          showForm.value = false;
          return;
        }
        var result = await repository.edit(editItem.value);
        if (result) {
          item
            ..shopName = editItem.value.shopName
            ..name = editItem.value.name
            ..email = editItem.value.email
            ..phone = editItem.value.phone;
          items.refresh();
        }
      }
      showForm.value = false;
    }
  }
}
