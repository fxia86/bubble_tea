import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/data/models/special_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/dish_repository.dart';
import 'package:bubble_tea/data/repositories/order_repository.dart';
import 'package:bubble_tea/data/repositories/printer_repository.dart';
import 'package:bubble_tea/data/repositories/special_repository.dart';
import 'package:bubble_tea/routes/pages.dart';
// import 'package:bubble_tea/utils/loading_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:queue/queue.dart';

class ReceptionController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;

  var shopId = LocalStorage.getAuthUser().shopId;
  var shopName = LocalStorage.getAuthUser().shopName;
  var shopAddress = LocalStorage.getAuthUser().shopAddress;
  var shopPhone = LocalStorage.getAuthUser().shopPhone;

  var catalogs = <CatalogModel>[].obs;
  var dishes = <DishModel>[].obs;
  var popularList = <DishModel>[].obs;

  BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
  var pairedPrinters = <BluetoothDevice>[].obs;
  var printers = <PrinterModel>[];

  var specialDiscounts = <SpecialDiscountModel>[];
  var specialBundles = <SpecialBundleModel>[];
  var specialPrices = <SpecialPriceModel>[];

  var orderList = <OrderDishModel>[].obs;
  var currentItem = DishModel().obs;
  var currentOptions = <DishOptionModel>[].obs;
  var currentPrice = 0.obs;
  var currentQty = 1.obs;
  var currentOptionMap = {};

  var confirmList = [];
  var totalAmount = 0;
  var payment = 1.obs;
  var amountPaid = 0.obs;
  var discount = 0.obs;

  var searching = false.obs;
  var keywords = "".obs;

  final printTaskQueue = Queue(delay: const Duration(milliseconds: 100));

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: catalogs.length, vsync: this);
  }

  @override
  void onReady() async {
    await refresh();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void initPrinters() async {
    try {
      final devices = await bluetoothPrinter.getBondedDevices();
      pairedPrinters.value = devices
          .where((element) => element.name!.toLowerCase().contains("print"))
          .toList();
    } catch (e) {
      PlatformException exception = e as PlatformException;
      MessageBox.error(exception.code, exception.message ?? "");
    }
  }

  Future<void> refresh() async {
    catalogs.value = await Get.find<CatalogRepository>().getAll();
    catalogs.insert(0, CatalogModel(name: "Popular"));
    tabController.animateTo(0);
    tabController = TabController(length: catalogs.length, vsync: this);

    dishes.value = await Get.find<DishRepository>().getAll(showLoading: false);
    popularList.value = dishes.where((element) => element.isPopular!).toList();
    if (popularList.length < 9) {
      for (var item in dishes.where((element) => !element.isPopular!)) {
        popularList.add(item);
        if (popularList.length >= 9) {
          break;
        }
      }
    }

    Get.find<SpecialDiscountRepository>()
        .getAll()
        .then((value) => specialDiscounts = value);
    Get.find<SpecialPriceRepository>()
        .getAll()
        .then((value) => specialPrices = value);
    Get.find<SpecialBundleRepository>()
        .getAll()
        .then((value) => specialBundles = value);

    Get.find<PrinterRepository>()
        .getAll(shopId: shopId)
        .then((value) => printers = value);

    initPrinters();

    reset();
  }

  logout() {
    LocalStorage.clearAuthInfo();
    Get.offNamed(Routes.LOGIN);
  }

  setCurrent(DishModel item) {
    currentItem(item);
    currentPrice(item.price);
    currentQty(1);
    currentOptions([]);
    currentOptionMap = groupBy(
        currentItem.value.options, (DishOptionModel o) => o.additionName);
  }

  setOption(DishOptionModel option, bool add) {
    if (add) {
      // if (currentOptions
      //     .any((element) => element.additionName == option.additionName)) {
      //   currentOptions.removeWhere(
      //       (element) => element.additionName == option.additionName);
      // }

      // currentPrice.value = currentItem.value.price!;
      // currentOptions.forEach((element) {
      //   currentPrice.value += element.price!;
      // });

      currentOptions.add(option);
      currentPrice.value += option.price!;
    } else {
      currentOptions.remove(option);
      currentPrice.value -= option.price!;
    }
  }

  order([DishModel? item]) {
    if (item == null) {
      // if (currentOptions.length != currentOptionMap.length) {
      //   return;
      // }

      currentOptions.sort((a, b) =>
          a.optionName!.toLowerCase().compareTo(b.optionName!.toLowerCase()));

      final optionIds =
          currentOptions.map((element) => element.optionId).join(",");

      final idx = orderList.indexWhere((element) =>
          element.dishId == currentItem.value.id &&
          element.optionIds == optionIds);
      if (idx > -1) {
        orderList[idx].qty = orderList[idx].qty! + currentQty.value;
        orderList.refresh();
      } else {
        final desc = currentItem.value.name! +
            " + " +
            currentOptions
                .map((element) =>
                    "${element.optionName}" +
                    (element.price! > 0
                        ? " € ${(element.price! / 100).toStringAsFixed(2)}"
                        : ""))
                .join(" + ");

        orderList.add(OrderDishModel(
            dishId: currentItem.value.id,
            desc: desc,
            optionIds: optionIds,
            originalPrice: currentPrice.value,
            offerPrice: currentPrice.value,
            qty: currentQty.value));
      }
    } else {
      final dish = orderList.firstWhere((element) => element.dishId == item.id,
          orElse: () {
        var dish = OrderDishModel(
            dishId: item.id,
            desc: item.name,
            originalPrice: item.price,
            offerPrice: item.price,
            qty: 0);

        orderList.add(dish);
        return dish;
      });

      dish.qty = dish.qty! + 1;
      orderList.refresh();
    }
    Get.back();
  }

  placeOrder() async {
    var order = OrderModel(
      shopId: shopId,
      payment: payment.value,
      originalPrice: orderList
          .fold(
              0,
              (int previousValue, element) =>
                  previousValue + element.offerPrice! * element.qty!)
          .toInt(),
      offerPrice: (totalAmount * (1 - discount / 100)).toInt(),
      discount: discount.value,
    )..dishes = confirmList
        .expand((element) => element as List<OrderDishModel>)
        .toList();

    var result = await Get.find<OrderRepository>().save(order.toJson());
    var orderDishList =
        List.from(orderList.map((element) => OrderDishModel.copyWith(element)));
    var paid = payment.value == 1 ? result.offerPrice : amountPaid.value;
    reset();

    //print
    if (pairedPrinters.length > 0 && printers.length > 0) {
      // bluetoothPrinter.isConnected.then((isConnected) async {
      //   if (isConnected!) {
      //     await bluetoothPrinter.disconnect();
      //   }
      // });
      // LoadingBox.show();
      for (var item in printers) {
        printTaskQueue.add(() async {
          try {
            var printer = pairedPrinters
                .firstWhere((element) => element.address == item.address);
            await bluetoothPrinter.connect(printer);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printCustom(item.shopName!, 3, 1);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printCustom("Address: $shopAddress", 0, 0);
            bluetoothPrinter.printCustom("Tel: $shopPhone", 0, 0);
            bluetoothPrinter.printCustom("Order SN: ${result.sn}", 0, 0);
            bluetoothPrinter.printCustom("Order Time: ${result.date}", 0, 0);
            printDevider();
            // bluetoothPrinter.printLeftRight("Item", "Qty", 1);
            bluetoothPrinter.print4Column(
                "Item".padRight(20), "UnitPrice", "Qty", "Subtotal", 1);
            bluetoothPrinter.printNewLine();
            for (var orderItem in orderDishList) {
              var dish = dishes
                  .firstWhere((element) => element.id == orderItem.dishId);
              if (dish.printers
                  .any((element) => element.printerId == item.id)) {
                // bluetoothPrinter.printLeftRight(
                //     dish.name!, orderItem.qty.toString(), 1);
                bluetoothPrinter.print4Column(
                    dish.name!.padRight(20),
                    "€ ${(orderItem.offerPrice / 100).toStringAsFixed(2)}"
                        .padLeft(9),
                    orderItem.qty.toString().padLeft(3),
                    "€ ${(orderItem.offerPrice * orderItem.qty / 100).toStringAsFixed(2)}"
                        .padLeft(8),
                    1,
                    charset: "windows-1256");

                var options = orderItem.desc!
                    .split(" + ")
                    .skip(1)
                    .join(" ,  ")
                    .replaceAll(RegExp(r" € \d[.]\d{2}"), "");
                if (options.trim().length > 0) {
                  bluetoothPrinter.printCustom(options, 0, 0);
                }
                bluetoothPrinter.printNewLine();
              }
            }
            bluetoothPrinter.print4Column(
                "".padRight(8), "", "", "".padRight(22, "-"), 1);
            if (order.discount! > 0) {
              bluetoothPrinter.print4Column("".padRight(10), "", "",
                  "Extra Discount: ${order.discount}%", 1);
            }
            bluetoothPrinter.print4Column("".padRight(16), "", "",
                "Total: € ${(result.offerPrice! / 100).toStringAsFixed(2)}", 1,
                charset: "windows-1256");
            bluetoothPrinter.print4Column(
                "".padRight(11),
                "",
                "",
                "Paid(${result.payment == 1 ? "Card" : "Cash"}): € ${(paid / 100).toStringAsFixed(2)}",
                1,
                charset: "windows-1256");
            bluetoothPrinter.print4Column(
                "".padRight(15),
                "",
                "",
                "Change: € ${((paid - result.offerPrice!) / 100).toStringAsFixed(2)}",
                1,
                charset: "windows-1256");

            printDevider();

            bluetoothPrinter.printCustom("Thanks for your patronage!", 0, 1);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printCustom(result.sn!.split('-')[1], 4, 1);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printCustom("", 3, 1);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.printCustom("", 3, 1);
            bluetoothPrinter.printNewLine();
            bluetoothPrinter.paperCut();

            await bluetoothPrinter.disconnect();

            await Future.delayed(Duration(seconds: 1));
          } catch (e) {
            print(e);
          }
        });
      }
      // LoadingBox.hide();
    }
  }

  printDevider() {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    // 4- bold & huge
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    bluetoothPrinter.printCustom(
        "------------------------------------------------", 0, 1);
  }

  reset() {
    orderList.value = <OrderDishModel>[];
    currentItem.value = DishModel();
    currentOptions.value = <DishOptionModel>[];
    currentPrice.value = 0;
    currentQty.value = 1;
    currentOptionMap = {};

    confirmList = [];
    totalAmount = 0;
    payment.value = 1;
    amountPaid.value = 0;
  }
}
