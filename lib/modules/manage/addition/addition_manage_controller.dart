import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/repositories/addition_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class AdditionManageController extends GetxController {
  final AdditionRepository repository = Get.find();

  var showForm = false.obs;
  var isNew = true.obs;

  var items = <AdditionModel>[].obs;
  var editItem = AdditionModel().obs;
  var editOptionItem = AdditionOptionModel().obs;
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

  void add() {
    showForm.value = true;
    isNew.value = true;
    editItem.value = AdditionModel();
  }

  void edit(String? id) {
    showForm.value = true;
    isNew.value = false;
    var item = items.singleWhere((element) => element.id == id);
    editItem.value = AdditionModel(id: item.id, name: item.name);
  }

  void deleteConfirm(String? id) {
    final item = items.singleWhere((element) => element.id == id);
    ConfirmBox.show("Addition ${item.name}", () => delete(id));
  }

  void delete(String? id) async {
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
        var item = await repository.add(editItem.value);
        items.insert(0, item);
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

  void addOption(String? id) {
    isNew.value = true;
    editOptionItem.value = AdditionOptionModel(additionId: id);
  }

  void editOption(String? id) {
    isNew.value = false;
    final item = items
        .expand((element) => element.options)
        .where((element) => element.id == id)
        .first;
    editOptionItem.value = AdditionOptionModel(
        id: item.id, additionId: item.additionId, name: item.name);
  }

  void deleteOptionConfirm(String? id) {
    final item = items
        .expand((element) => element.options)
        .where((element) => element.id == id)
        .first;
    ConfirmBox.show("Option ${item.name}", () => deleteOption(id));
  }

  void deleteOption(String? id) async {
    final idx = items
        .expand((element) => element.options)
        .toList()
        .indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await repository.deleteOption(id);
      if (result) {
        items
            .firstWhere(
                (element) => element.id == editOptionItem.value.additionId)
            .options
            .removeAt(idx);
        items.refresh();
      }
    }
  }

  saveOption() async {
    if (editOptionItem.value.name == null ||
        editOptionItem.value.name!.isEmpty) {
      MessageBox.error('Invalid name');
    } else {
      final options = items.expand((element) => element.options).toList();

      final idx = options.indexWhere((element) =>
          element.name == editOptionItem.value.name &&
          element.additionId == editOptionItem.value.additionId &&
          element.id != editOptionItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      if (isNew.value) {
        var item = await repository.addOption(editOptionItem.value);
        items
            .firstWhere(
                (element) => element.id == editOptionItem.value.additionId)
            .options
            .insert(0, item);
        items.refresh();
      } else {
        var item = options
            .singleWhere((element) => element.id == editOptionItem.value.id);
        if (item.name == editOptionItem.value.name) {
          return;
        }
        var result = await repository.editOption(editOptionItem.value);
        if (result) {
          item..name = editOptionItem.value.name;
          items.refresh();
        }
      }
    }
  }
}
