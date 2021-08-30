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
  var radioValue = 0.obs;
  var shopId = "".obs;
  var shopName = "".obs;
  String? name;
  String? address;
  var alias = "".obs;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  var pairedPrinters = <BluetoothDevice>[].obs;

  @override
  void onReady() async {
    super.onReady();

    initPrinters();

    // ever(radioValue, (_) => edit());

    items.value = await repository.getAll();
    shops = await Get.find<ShopRepository>().getAll();
  }

  void initPrinters() async {
    try {
      final devices = await bluetooth.getBondedDevices();
      pairedPrinters.value = devices
          // .where((element) => element.name!.toLowerCase().contains("print"))
          .toList();
    } catch (e) {
      PlatformException exception = e as PlatformException;
      MessageBox.error(exception.code, exception.message ?? "");
    }
  }

  void deleteConfirm(String? id) {
    final item = items.singleWhere((element) => element.id == id);
    ConfirmBox.show("${item.shopName} - ${item.alias}", () => delete(id));
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

  void selectPrinter(int? val) {
    radioValue(val);
    var printer = pairedPrinters[radioValue.value - 1];
    name = printer.name;
    address = printer.address;
  }

  void selectShop(ShopModel item) {
    shopId(item.id);
    shopName(item.name);
  }

  void save() async {
    if (shopId.value.isEmpty) {
      MessageBox.error('Please select a shop');
    } else if (alias.isEmpty) {
      MessageBox.error('Invalid name');
    } else {
      final idx = items.indexWhere((element) =>
          (element.alias == alias.value && element.shopId == shopId.value) ||
          element.address == address);
      if (idx > -1) {
        MessageBox.error('Duplicated', 'this printer was already added');
        return;
      }

      var item = PrinterModel(
          name: name,
          address: address,
          shopId: shopId.value,
          shopName: shopName.value,
          alias: alias.value);

      var result = await repository.add(item);
      items.insert(0, item..id = result.id);
    }
  }
}
