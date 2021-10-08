import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_controller.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:collection/collection.dart';

class DishDetailController extends GetxController {
  final DishRepository repository = Get.find();

  final MenuManageController _parent = Get.find<MenuManageController>();

  String? dishId;

  var category = 1.obs;

  var dishMaterials = <DishMaterialModel>[].obs;
  var dishPrinters = <DishPrinterModel>[].obs;
  var dishOptions = <DishOptionModel>[].obs;

  var editItem = DishModel().obs;

  final _picker = ImagePicker();
  XFile? _image;
  var imagePath = "".obs;

  var dishOptionMaterialId = "".obs;
  var dishOptionMaterialQty = 1.obs;

  FocusNode qtyFocusNode = FocusNode();
  @override
  void onInit() {
    super.onInit();
    qtyFocusNode.addListener(() {
      if (qtyFocusNode.hasFocus) {
      } else {
        for (var item in dishMaterials) {
          item.selected = false;
        }
        dishMaterials.refresh();
      }
    });

    dishId = Get.arguments;

    if (dishId == null) {
      // new
      imagePath.value = "";
      editItem.value = DishModel();
      dishMaterials.value = <DishMaterialModel>[];
    } else {
      // edit
      var item = _parent.items.singleWhere((element) => element.id == dishId);
      var materials = item.materials.map((e) => DishMaterialModel(
            id: e.id,
            dishId: e.dishId,
            materialId: e.materialId,
            materialName: _parent.materials
                .firstWhere((element) => element.id == e.materialId)
                .name,
            qty: e.qty,
          ));

      var options = item.options.map((e) => DishOptionModel(
            id: e.id,
            dishId: e.dishId,
            additionId: e.additionId,
            optionId: e.optionId,
            materialId: e.materialId,
            optionName: e.optionName,
            additionName: e.additionName,
            qty: e.qty,
            price: e.price,
          ));

      editItem.value = DishModel(
        id: dishId,
        img: item.img,
        catalogId: item.catalogId,
        name: item.name,
        code: item.code,
        desc: item.desc,
        price: item.price,
        isPopular: item.isPopular,
      )
        ..materials = materials.toList()
        ..printers = item.printers
        ..options = options.toList();

      dishMaterials.value = List.from(materials);
      dishPrinters.value = List.from(item.printers);
      dishOptions.value = List.from(options);
    }
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    qtyFocusNode.dispose();
    super.onClose();
  }

  void pickImage(int source) async {
    _image = await _picker.pickImage(
      source: source == 1 ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 400,
      // maxHeight: maxHeight,
      // imageQuality: quality,
    );
    if (_image != null) {
      imagePath.value = _image!.path;
      editItem.value.img = imagePath.value;
    }
  }

  void selectCatalog(CatalogModel item) {
    editItem.value.catalogId = item.id;
    editItem.refresh();
  }

  void save() async {
    if (editItem.value.catalogId == null || editItem.value.catalogId!.isEmpty) {
      MessageBox.error('Please select a shop');
    } else if (editItem.value.name == null || editItem.value.name!.isEmpty) {
      MessageBox.error('Invalid name');
      // } else if (editItem.value.desc == null || editItem.value.desc!.isEmpty) {
      //   MessageBox.error('Invalid description');
    } else if (editItem.value.price == null || editItem.value.price! <= 0) {
      MessageBox.error('Invalid price', 'It should be a number.');
    } else {
      final idx = _parent.items.indexWhere((element) =>
          (element.name == editItem.value.name ||
              element.code == editItem.value.code) &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Item');
        return;
      }
      if (editItem.value.code == null || editItem.value.code!.isEmpty) {
        var number = 1;
        _parent.items.forEach((element) {
          if (element.id != editItem.value.id &&
              element.code!.contains("AUTO-")) {
            var code = int.parse(element.code!.replaceFirst("AUTO-", ""));
            if (code >= number) {
              number = code + 1;
            }
          }
        });
        editItem.value.code = "AUTO-$number";
      }
      var data = editItem.value.toJson();
      if (imagePath.value.isNotEmpty) {
        data["file_img"] = await dio.MultipartFile.fromFile(imagePath.value);
      }
      if (dishId == null) {
        if (imagePath.value.isEmpty) {
          MessageBox.error('No image found');
          return;
        }
        data["serial"] = _parent.items
                .where((e) => e.catalogId == editItem.value.catalogId)
                .length +
            1;
        var item = await repository.add(data);
        _parent.items.add(item);
        _parent.sortItems();
        editItem.value.id = item.id;
        dishId = item.id;
      } else {
        var item = _parent.items
            .singleWhere((element) => element.id == editItem.value.id);
        if (imagePath.value.isEmpty &&
            item.catalogId == editItem.value.catalogId &&
            item.name == editItem.value.name &&
            item.code == editItem.value.code &&
            item.desc == editItem.value.desc &&
            item.price == editItem.value.price &&
            item.isPopular == editItem.value.isPopular) {
          return;
        }
        var result = await repository.edit(data);

        item
          ..catalogId = result.catalogId
          ..name = result.name
          ..code = result.code
          ..img = result.img
          ..desc = result.desc
          ..price = result.price
          ..isPopular = result.isPopular;
        _parent.items.refresh();
      }

      editItem.refresh();
      MessageBox.success();
    }
  }

  void addMaterial(MaterialModel v) {
    var item = dishMaterials.singleWhere(
      (element) => element.materialName == v.name,
      orElse: () {
        var item = DishMaterialModel(
          dishId: dishId,
          materialId: v.id,
          materialName: v.name,
          qty: 0,
        );
        dishMaterials.add(item);
        return item;
      },
    );

    item.qty = item.qty! + 1;
    dishMaterials.refresh();
  }

  void removeMaterial(int index) {
    dishMaterials.removeAt(index);
  }

  saveMaterial() async {
    if (_existDish()) {
      // if (dishMaterials.length == 0) {
      //   MessageBox.error("No materials to save");
      // }
      if (_notEqualList(dishMaterials, editItem.value.materials)) {
        var result = await repository.saveDishMaterials(dishId, dishMaterials);
        if (result) {
          final list = dishMaterials
              .map((element) => DishMaterialModel.fromJson(element.toJson()))
              .toList();
          editItem.value.materials = list;

          var item =
              _parent.items.singleWhere((element) => element.id == dishId);
          item.materials = list;

          MessageBox.success();
        }
      }
    }
  }

  addPrinter(String? id, bool add) {
    if (add) {
      dishPrinters.add(DishPrinterModel(
        dishId: dishId,
        printerId: id,
      ));
    } else {
      dishPrinters.removeWhere((element) => element.printerId == id);
    }
  }

  savePrinter() async {
    if (_existDish() && _notEqualList(dishPrinters, editItem.value.printers)) {
      var result = await repository.saveDishPrinters(dishId, dishPrinters);
      if (result) {
        final list = dishMaterials
            .map((element) => DishPrinterModel.fromJson(element.toJson()))
            .toList();
        editItem.value.printers = list;

        var item = _parent.items.singleWhere((element) => element.id == dishId);
        item.printers = list;

        MessageBox.success();
      }
    }
  }

  addAddition(AdditionOptionModel option, String? additionName, bool add) {
    if (add) {
      dishOptions.add(DishOptionModel(
          dishId: dishId,
          additionId: option.additionId,
          additionName: additionName,
          optionId: option.id,
          optionName: option.name,
          qty: 0));
    } else {
      dishOptions.removeWhere((element) => element.optionId == option.id);
    }
  }

  saveAddition() async {
    if (_existDish() && _notEqualList(dishOptions, editItem.value.options)) {
      var result = await repository.saveDishOptions(dishId, dishOptions);
      if (result) {
        final list = dishMaterials
            .map((element) => DishOptionModel.fromJson(element.toJson()))
            .toList();
        editItem.value.options = list;

        var item = _parent.items.singleWhere((element) => element.id == dishId);
        item.options = list;

        MessageBox.success();
      }
    }
  }

  bool _existDish() {
    if (dishId == null || dishId!.isEmpty) {
      MessageBox.warn("Fill in the Basic Information Form fisrt");
      return false;
    }
    return true;
  }

  bool _notEqualList(List list1, List list2) {
    if (list1.length == list2.length) {
      if (DeepCollectionEquality.unordered().equals(list1, list2)) {
        return false;
      }
    }

    return true;
  }
}
