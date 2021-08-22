import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class CatalogManageController extends GetxController {
  final CatalogRepository repository = Get.find();

  var showForm = false.obs;
  var isNew = true.obs;

  var items = <CatalogModel>[].obs;
  var editItem = CatalogModel().obs;
  var keywords = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    items.value = await repository.getAll();
  }

  @override
  void onClose() {
    // dataSource.dispose();
    super.onClose();
  }

  void add() {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = true;
      editItem.value = CatalogModel();
    }
  }

  void edit(String? id) {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = false;
      var item = items.singleWhere((element) => element.id == id);
      editItem.value = CatalogModel(name: item.name, serial: item.serial);
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

  void save() async {
    if (editItem.value.name == null || editItem.value.name!.isEmpty) {
      MessageBox.error('Invalid name');
    } else {
      final idx = items.indexWhere((element) =>
          element.name == editItem.value.name &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      if (isNew.value) {
        editItem.value.serial = items.length + 1;
        var item = await repository.add(editItem.value);
        items.add(item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);
        if (item.name == editItem.value.name) {
          showForm.value = false;
          return;
        }
        var result = await repository.edit(editItem.value);
        if (result) {
          item..name = editItem.value.name;
          items.refresh();
        }
      }
      showForm.value = false;
    }
  }

  reorder(int oldIndex, int newIndex) async {
    var item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    await repository.reorder(item.id, oldIndex + 1, newIndex + 1,
        showLoading: false);
  }
}
