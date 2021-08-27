import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/repositories/addition_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
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

  var id = Get.arguments;

  var category = 1.obs;

  var materials = <MaterialModel>[].obs;
  var printers = <PrinterModel>[];
  var printerMap = {};
  var additions = <AdditionModel>[];
  var dishMaterials = <DishMaterialModel>[].obs;
  var dishPrinters = <PrinterModel>[].obs;

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

    if (id != null) {
      // edit
      var item = _parent.items.singleWhere((element) => element.id == id);
      editItem.value = DishModel(
          id: id,
          img: item.img,
          catalogId: item.catalogId,
          name: item.name,
          desc: item.desc,
          price: item.price,
          isPopular: item.isPopular);
    } else {
      // new
      imagePath.value = "";
      editItem.value = DishModel();
      dishMaterials.value = <DishMaterialModel>[];
    }
  }

  @override
  void onReady() async {
    super.onReady();

    materials.value = await Get.find<MaterialRepository>().getAll();
    materials.sort((a, b) => a.name!.compareTo(b.name!));

    printers = await Get.find<PrinterRepository>().getAll(showLoading: false);

    printerMap = groupBy(printers, (PrinterModel p) => p.shopName);
    additions = await Get.find<AdditionRepository>().getAll(showLoading: false);
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
      if (id == null) {
        if (imagePath.value.isEmpty) {
          MessageBox.error('No image found');
          return;
        }
        var item = await repository.add(data);
        _parent.items.insert(0, item);
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
        // _parent.items.refresh();
      }
    }
  }

  void addMaterial(MaterialModel v) {
    var item = dishMaterials.singleWhere(
      (element) => element.materialName == v.name,
      orElse: () {
        var item = DishMaterialModel(
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
    if (_existDish() &&
        dishMaterials.length > 0 &&
        !_compareListByItemIds(dishMaterials, editItem.value.materials)) {
      // if (await repository.saveDishMaterials(dishMaterials)) {
      //   editItem.value.printers = [];
      // }
    }
  }

  addPrinter(String? id, bool add) {
    if (add) {
      // dishPrinters.add();
    } else {
      dishPrinters.removeWhere((element) => element.id == id);
    }
  }

  savePrinter() async {
    if (_existDish() &&
        dishPrinters.length > 0 &&
        !_compareListByItemIds(dishPrinters, editItem.value.printers)) {
      // if (await repository.saveDishPrinters(dishPrinters)) {
      //   editItem.value.printers = [];
      // }
    }
  }

  saveAddition() async {
    if (_existDish() &&
        dishPrinters.length > 0 &&
        !_compareListByItemIds(dishPrinters, editItem.value.printers)) {
      // if (await repository.saveDishPrinters(dishPrinters)) {
      //   editItem.value.printers = [];
      // }
    }
  }

  bool _existDish() {
    if (editItem.value.id == null || editItem.value.id!.isEmpty) {
      MessageBox.warn("Fill in the Basic Information Form fisrt");
      return false;
    }
    return true;
  }

  bool _compareListByItemIds(List list1, List list2) {
    var list3 = list1.map((e) => e["id"]).toList();
    list3.sort();
    var list4 = list1.map((e) => e["id"]).toList();
    list4.sort();

    return list3.join() == list4.join();
  }
}
