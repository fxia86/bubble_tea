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

  var itemId;

  var category = 1.obs;

  var dishMaterials = <DishMaterialModel>[].obs;
  var dishPrinters = <DishPrinterModel>[].obs;
  var dishOptions = <DishOptionModel>[].obs;

  var editItem = DishModel().obs;

  final _picker = ImagePicker();
  XFile? _image;
  var imagePath = "".obs;

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

    itemId = Get.arguments;

    if (itemId == "") {
      // new
      imagePath.value = "";
      editItem.value = DishModel();
      dishMaterials.value = <DishMaterialModel>[];
    } else {
      // edit
      var item = _parent.items.singleWhere((element) => element.id == itemId);
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
            additionId: _parent.additions
                .firstWhere((element) =>
                    element.options.any((element) => element.id == e.optionId))
                .id,
            optionId: e.optionId,
            price: e.price,
          ));

      editItem.value = DishModel(
        id: itemId,
        img: item.img,
        catalogId: item.catalogId,
        name: item.name,
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
          element.name == editItem.value.name &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      var data = editItem.value.toJson();
      if (imagePath.value.isNotEmpty) {
        data["file_img"] = await dio.MultipartFile.fromFile(imagePath.value);
      }
      if (itemId == null) {
        if (imagePath.value.isEmpty) {
          MessageBox.error('No image found');
          return;
        }
        var item = await repository.add(data);
        _parent.items.insert(0, item);
        itemId = item.id;
      } else {
        var item = _parent.items
            .singleWhere((element) => element.id == editItem.value.id);
        if (imagePath.value.isEmpty &&
            item.catalogId == editItem.value.catalogId &&
            item.name == editItem.value.name &&
            item.desc == editItem.value.desc &&
            item.price == editItem.value.price &&
            item.isPopular == editItem.value.isPopular) {
          return;
        }
        var result = await repository.edit(data);

        item
          ..name = result.name
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
          dishId: itemId,
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
        var result = await repository.saveDishMaterials(itemId, dishMaterials);
        if (result) {
          editItem.value.materials = List.from(dishMaterials);

          var item =
              _parent.items.singleWhere((element) => element.id == itemId);
          item.materials = List.from(dishMaterials);

          MessageBox.success();
        }
      }
    }
  }

  addPrinter(String? id, bool add) {
    if (add) {
      dishPrinters.add(DishPrinterModel(
        dishId: itemId,
        printerId: id,
      ));
    } else {
      dishPrinters.removeWhere((element) => element.printerId == id);
    }
  }

  savePrinter() async {
    if (_existDish() && _notEqualList(dishPrinters, editItem.value.printers)) {
      var result = await repository.saveDishPrinters(itemId, dishPrinters);
      if (result) {
        editItem.value.printers = List.from(dishPrinters);

        var item = _parent.items.singleWhere((element) => element.id == itemId);
        item.printers = List.from(dishPrinters);

        MessageBox.success();
      }
    }
  }

  addAddition(String? id, String? additionId, bool add) {
    if (add) {
      dishOptions.add(DishOptionModel(
        dishId: itemId,
        additionId: additionId,
        optionId: id,
      ));
    } else {
      dishOptions.removeWhere((element) => element.optionId == id);
    }
  }

  saveAddition() async {
    if (_existDish() && _notEqualList(dishOptions, editItem.value.options)) {
      var result = await repository.saveDishOptions(itemId, dishOptions);
      if (result) {
        editItem.value.options = List.from(dishOptions);

        var item = _parent.items.singleWhere((element) => element.id == itemId);
        item.options = List.from(dishOptions);

        MessageBox.success();
      }
    }
  }

  bool _existDish() {
    if (editItem.value.id == null || editItem.value.id!.isEmpty) {
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
