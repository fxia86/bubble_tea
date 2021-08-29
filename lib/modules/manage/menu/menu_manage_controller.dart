import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/repositories/addition_repository.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class MenuManageController extends GetxController
    with SingleGetTickerProviderMixin {
  final DishRepository repository = Get.find();
  late TabController tabController;

  var catalogs = <CatalogModel>[].obs;
  var items = <DishModel>[].obs;

  var materials = <MaterialModel>[];
  var printers = <PrinterModel>[];
  var printerMap = {};
  var additions = <AdditionModel>[];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: catalogs.length, vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();

    catalogs.value = await Get.find<CatalogRepository>().getAll();
    catalogs.insert(0, CatalogModel(name: "Popular"));
    tabController = TabController(length: catalogs.length, vsync: this);
    items.value = await repository.getAll(showLoading: false);
    sortItems();

    materials = await Get.find<MaterialRepository>().getAll(showLoading: false);

    printers = await Get.find<PrinterRepository>().getAll(showLoading: false);
    printerMap = groupBy(printers, (PrinterModel p) => p.shopName);

    additions = await Get.find<AdditionRepository>().getAll(showLoading: false);
  }

  sortItems() {
    items.sort((x, y) {
      final i = x.serial!.compareTo(y.serial!);
      if (i == 0) {
        final catalogX =
            catalogs.firstWhere((element) => element.id == x.catalogId).serial;
        final catalogY =
            catalogs.firstWhere((element) => element.id == y.catalogId).serial;
        return catalogX!.compareTo(catalogY!);
      }
      return i;
    });
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

  void reorder(int oldIndex, int newIndex, String? catalogId) {
    final list = items.where((e) => e.catalogId == catalogId).toList();

    final _oldIndex =
        items.indexWhere((element) => element.id == list[oldIndex].id);
    final _newIndex =
        items.indexWhere((element) => element.id == list[newIndex].id);

    final item = items.removeAt(_oldIndex);
    item.serial = newIndex + 1;
    items.insert(_newIndex, item);

    sortItems();
    repository.reorder(item.id, oldIndex + 1, newIndex + 1, showLoading: false);
  }
}
