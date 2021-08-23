import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class MenuManageController extends GetxController
    with SingleGetTickerProviderMixin {
  final DishRepository repository = Get.find();
  late TabController tabController;

  var isNew = true.obs;

  var catalogs = <CatalogModel>[];
  var materials = <MaterialModel>[];
  var printers = <PrinterModel>[];
  var printerMap = {};
  var dishMaterials = <DishMaterialModel>[].obs;
  var items = <DishModel>[].obs;
  var editItem = DishModel().obs;

  final _picker = ImagePicker();
  XFile? _image;
  var imagePath = "".obs;
  
  FocusNode qtyFocusNode = FocusNode();
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: catalogs.length, vsync: this);
    qtyFocusNode.addListener(() {
      if (qtyFocusNode.hasFocus) {
      } else {
        for (var item in dishMaterials) {
          item.selected = false;
        }
        dishMaterials.refresh();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();

    catalogs = await Get.find<CatalogRepository>().getAll();
    catalogs.insert(0, CatalogModel(name: "Popular"));
    tabController = TabController(length: catalogs.length, vsync: this);

    repository.getAll(showLoading: false).then((value) {
      items.value = value;
    });

    Get.find<MaterialRepository>().getAll(showLoading: false).then((value) {
      materials = value;
      materials.sort((a,b)=>a.name!.compareTo(b.name!));
    });

    Get.find<PrinterRepository>().getAll(showLoading: false).then((value) {
      printers = value;
      printerMap = groupBy(printers, (PrinterModel p) => p.shopName);
    });
  }

  @override
  void onClose() {
    // qtyFocusNode.dispose();
    super.onClose();
  }

  void add() {
    isNew.value = true;
    editItem.value = DishModel();
    dishMaterials.value = <DishMaterialModel>[];
  }

  void edit(String? id) {
    isNew.value = false;
    var item = items.singleWhere((element) => element.id == id);
    editItem.value = DishModel(name: item.name);
    editItem.value.id = item.id;

    // repository.getAll(showLoading: false).then((value) => null);
  }

  void deleteConfirm(String? id) {
    final item = items.singleWhere((element) => element.id == id);
    ConfirmBox.show(item.name, () => delete(id));
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
    editItem.value.catalogName = item.name;
    editItem.refresh();
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
        items.add(item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);
        if (item.name == editItem.value.name) {
          // editQty.value = false;
          return;
        }
        var result = await repository.edit(editItem.value);
        if (result) {
          item..name = editItem.value.name;
          items.refresh();
        }
      }
      // editQty.value = false;
    }
  }

  void reorder(int oldIndex, int newIndex) {
    var item = items.elementAt(oldIndex);
    repository.reorder(item.id, oldIndex + 1, newIndex + 1).then((value) {
      if (value) {
        items.remove(item);
        items.insert(newIndex, item);
      }
    });
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
}
