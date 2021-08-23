import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PrinterManageController extends GetxController {
  final PrinterRepository repository = Get.find();

  var shops = <ShopModel>[];
  var items = <PrinterModel>[].obs;
  var editItem = PrinterModel().obs;
  var radioValue = 0.obs;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  var pairedPrinters = <BluetoothDevice>[].obs;

  @override
  void onReady() async {
    super.onReady();

    initPrinters();

    ever(radioValue, (_) => edit());

    items.value = await repository.getAll();
    shops = await Get.find<ShopRepository>().getAll();

    // dataSource = ShopDataSource();
  }

  @override
  void onClose() {
    // dataSource.dispose();
    super.onClose();
  }

  void initPrinters() async {
    try {
      final devices = await bluetooth.getBondedDevices();
      // pairedPrinters.value = devices;
      pairedPrinters.value = devices
          .where((element) => element.name!.toLowerCase().contains("print"))
          .toList();
    } catch (e) {
      PlatformException exception = e as PlatformException;
      MessageBox.error(exception.code, exception.message ?? "");
    }
  }

  void edit() {
    var printer = pairedPrinters[radioValue.value - 1];

    var item = items.singleWhere(
        (element) => element.address == printer.address, orElse: () {
      return PrinterModel(name: printer.name, address: printer.address);
    });

    editItem.value = PrinterModel(
        name: item.name,
        address: item.address,
        alias: item.alias,
        shopId: item.shopId,
        shopName: item.shopName);
    editItem.value.id = item.id;
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

  void selectShop(ShopModel item) {
    editItem.value.shopId = item.id;
    editItem.value.shopName = item.name;
    editItem.refresh();
  }

  void save() async {
    if (editItem.value.shopId == null || editItem.value.shopId!.isEmpty) {
      MessageBox.error('Please select a shop');
    } else if (editItem.value.alias == null || editItem.value.alias!.isEmpty) {
      MessageBox.error('Invalid name');
    } else {
      final idx = items.indexWhere((element) =>
          element.alias == editItem.value.alias &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }

      if (editItem.value.id == null) {
        var item = await repository.add(editItem.value);
        items.insert(0, item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);

        if (item.shopId == editItem.value.shopId &&
            item.name == editItem.value.name &&
            item.address == editItem.value.address &&
            item.alias == editItem.value.alias) {
          return;
        }

        var result = await repository.edit(editItem.value);
        if (result) {
          item
            ..shopName = editItem.value.shopName
            ..alias = editItem.value.alias;
          items.refresh();
        }
      }
    }
  }
}
