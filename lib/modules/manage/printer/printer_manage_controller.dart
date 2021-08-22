import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class PrinterManageController extends GetxController {
  final PrinterRepository repository = Get.find();

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
    // dataSource = ShopDataSource();
  }

  @override
  void onClose() {
    // dataSource.dispose();
    super.onClose();
  }

  void initPrinters() async {
    final devices = await bluetooth.getBondedDevices();
    // pairedPrinters.value = devices
    //     .where((element) => element.name!.toLowerCase().contains("print"))
    //     .toList();
    pairedPrinters.value = devices;
  }

  void edit() {
    var printer = pairedPrinters[radioValue.value - 1];

    var item = items.singleWhere(
        (element) => element.address == printer.address, orElse: () {
      return PrinterModel(name: printer.name, address: printer.address);
    });
    editItem.value = item;
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

  void save() async {
    if (editItem.value.alias == null || editItem.value.alias!.isEmpty) {
      MessageBox.error('Invalid name');
    } else {
      // var item =
      //     items.singleWhere((element) => element.id == editItem.value.id);

      // if (item.name == editItem.value.name &&
      //     item.address == editItem.value.address) {
      //   return;
      // }
      // var result = await repository.edit(editItem.value);
      // if (result) {
      //   item
      //     ..name = editItem.value.name
      //     ..address = editItem.value.address;
      //   items.refresh();
      // }
    }
  }
}
