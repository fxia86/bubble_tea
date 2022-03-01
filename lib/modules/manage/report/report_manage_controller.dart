import 'dart:io';

import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/catalog_repository.dart';
import 'package:bubble_tea/data/repositories/order_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/utils/loading_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:path_provider/path_provider.dart';

class ReportManageController extends GetxController {
  final OrderRepository repository = Get.find();

  var shops = <ShopModel>[].obs;
  var items = <OrderModel>[].obs;
  var shopId = "".obs;
  var shopName = "select a shop".obs;
  var beginDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var lineDate = DateTime.now().obs;
  var selectedRowIndex = "".obs;
  var catalogs = <CatalogModel>[];
  var titles = ['Date', 'Shop', 'Cash', 'Card', 'Total'].obs;
  var rows = <Map<String, dynamic>>[].obs;
  var showDetail = false.obs;
  var category = 1.obs;
  var barchartData = <Series<BarItem, String>>[].obs;
  var linechartData = <Series<LineItem, num>>[].obs;
  final colorArray = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.black,
    Colors.orange,
    Colors.pink
  ];

  @override
  void onReady() async {
    super.onReady();

    shops.value = await Get.find<ShopRepository>().getAll();
    catalogs = await Get.find<CatalogRepository>().getAll();

    titles.value = [
      'Date',
      'Shop',
      ...catalogs.map((e) => e.name!),
      'Cash',
      'Card',
      'Total'
    ];

    await getData();
  }

  getData() async {
    rows.value = [];
    var statisticItems = await repository.getStatistic(
      beginDate: beginDate.toString(),
      endDate: endDate.toString(),
    );
    statisticItems.forEach((element) {
      var row = rows.firstWhere(
        (r) => r["date"] == element.date && r["shop"] == element.shop,
        orElse: () => {
          "date": element.date,
          "shop": element.shop,
          "cash": 0,
          "card": 0,
          "total": 0,
        },
      );
      rows.remove(row);
      row[element.catalogName!] = element.totalAmount;
      row["card"] += element.cardAmount;
      row["total"] += element.totalAmount;
      row["cash"] = row["total"] - row["card"];
      rows.add(row);
    });
  }

  export() async {
    if (rows.length == 0) {
      MessageBox.error("no data");
      return;
    }
    try {
      LoadingBox.show();
      var excel = Excel.createExcel();

      var sheetName = excel.getDefaultSheet() ?? "Sheet1";
      Sheet sheetObject = excel[sheetName];

      CellStyle cellStyle = CellStyle(fontSize: 14);

      sheetObject.insertRowIterables([...titles], 0);
      sheetObject.rows[0].forEach((element) {
        element!.cellStyle = cellStyle;
      });

      for (var i = 0; i < rows.length; i++) {
        var row = [];
        var item = rows[i];
        row.add(item["date"]);
        row.add(item["shop"]);
        catalogs.forEach((element) {
          row.add("€${((item[element.name] ?? 0) / 100).toStringAsFixed(2)}");
        });
        row.add("€${(item["cash"] / 100).toStringAsFixed(2)}");
        row.add("€${(item["card"] / 100).toStringAsFixed(2)}");
        row.add("€${(item["total"] / 100).toStringAsFixed(2)}");
        sheetObject.insertRowIterables(row, i + 1);
      }

      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();

      var filePath = "${directory.path}/report_.xlsx";
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      LoadingBox.hide();
      MessageBox.success("The excel has saved to path: $filePath");
    } catch (e) {
      LoadingBox.hide();
      print(e);
    }
    // var a = await File("${directory.path}/output_file_name.xlsx").create();
    // await a.writeAsBytes(fileBytes!);

    // var bytes =
    //     File("${directory.path}/output_file_name.xlsx").readAsBytesSync();
    // var excel1 = Excel.decodeBytes(bytes);

    // for (var table in excel1.tables.keys) {
    //   print(table); //sheet Name
    //   print(excel1.tables[table]?.maxCols);
    //   print(excel1.tables[table]?.maxRows);
    //   for (var row in excel.tables[table]!.rows) {
    //     print("$row");
    //   }
    // }
  }

  getDetail(date, shop) async {
    items.value = await repository.getAll(
        date: date,
        shopId: shops.firstWhere((element) => element.name == shop).id);
  }

  void selectShop(ShopModel item) {
    shopId(item.id);
    shopName(item.name);
  }

  getBarChartData() async {
    if (shopId.value == "") {
      MessageBox.error("Please select a shop!");
      return;
    }

    barchartData.value = [];
    var statisticItems = await repository.getStatistic(
        beginDate: beginDate.toString(),
        endDate: endDate.toString(),
        shopId: shopId.value);

    statisticItems.forEach((element) {
      var idx = barchartData.indexWhere((s) => s.id == element.date);
      var item = new BarItem(
          element.date!, element.catalogName!, element.totalAmount! / 100);
      if (idx > -1) {
        barchartData[idx].data.add(item);
      } else {
        barchartData.add(new Series<BarItem, String>(
            id: element.date!,
            data: [item],
            domainFn: (BarItem v, _) => v.catalog,
            measureFn: (BarItem v, _) => v.amount,
            labelAccessorFn: (BarItem v, _) => "${v.date.substring(5)}"));
      }
    });

    // barData.value = catalogs
    //     .map(
    //       (e) => new Series<BarItem, String>(
    //           id: e.name!,
    //           data: statisticItems
    //               .where((element) => element.catalogName == e.name)
    //               .map((element) => new BarItem(element.date!,
    //                   element.catalogName!, element.totalAmount! / 100))
    //               .toList(),
    //           domainFn: (BarItem v, _) => v.date,
    //           measureFn: (BarItem v, _) => v.amount,
    //           labelAccessorFn: (BarItem v, _) => "${v.catalog} €${v.amount}"),
    //     )
    //     .toList();
  }

  getLineChartData() async {
    linechartData.value = [];
    var statisticItems = await repository.getLineStatistic(
      date: lineDate.toString(),
    );

    statisticItems.forEach((element) {
      final shopName = shops.firstWhere((s) => s.id == element.shopId).name!;
      var idx = linechartData.indexWhere((s) => s.id == shopName);
      var item = new LineItem(element.hour!, element.num!);
      if (idx > -1) {
        linechartData[idx].data.add(item);
      } else {
        final c = colorArray[linechartData.length];
        linechartData.add(new Series<LineItem, num>(
            id: shopName,
            data: [item],
            // colorFn: (_, __) =>
            //     ColorUtil.fromDartColor(c),
            seriesColor: ColorUtil.fromDartColor(c),
            domainFn: (LineItem v, _) => v.hour,
            measureFn: (LineItem v, _) => v.num,
            labelAccessorFn: (_, __) => shopName));
      }
    });
  }
}

class BarItem {
  final String date;
  final String catalog;
  final double amount;

  BarItem(this.date, this.catalog, this.amount);
}

class LineItem {
  final int hour;
  final int num;

  LineItem(this.hour, this.num);
}
