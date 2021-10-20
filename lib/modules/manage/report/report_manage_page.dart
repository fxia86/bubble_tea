import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'report_manage_controller.dart';

class ReportManagePage extends GetView<ReportManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Daily Report",
      ),
      body: Column(
        children: [
          Row(
            children: [
              DatePicker(),
              Container(
                width: 300,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ShopSelect(),
              )
            ],
          ),
          Container(
              color: Colors.white,
              width: context.width,
              height: context.height * 0.35,
              child: StatisticTable()),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              color: Colors.white,
              width: context.width,
              child: OrderTable(),
            ),
          )
        ],
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Obx(() => Text(controller.date.toString().split(" ")[0],
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white))),
        onPressed: () => showDatePicker(
                    context: context,
                    initialDate: controller.date.value,
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now())
                .then((value) {
              if (value != null) {
                controller.date(value);
                controller.getData();
              }
            }));
  }
}

class StatisticTable extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView(children: [
      Obx(() => DataTable(
            dataRowHeight: 72,
            columns: [
              DataColumn(label: Text('Catalog')),
              DataColumn(label: Text('Cash')),
              DataColumn(label: Text('Card')),
              DataColumn(label: Text('Total')),
            ],
            rows: [
              for (var item in controller.statisticItems)
                DataRow(cells: [
                  DataCell(Text(item.catalogName ?? "")),
                  DataCell(Text(
                    "€${(item.totalAmount! - item.cardAmount!)
                      .toStringAsFixed(2)}"
                    )),
                  DataCell(Text("€${item.cardAmount!.toStringAsFixed(2)}")),
                  DataCell(Text("€${item.totalAmount!.toStringAsFixed(2)}")),
                ])
            ],
          ))
    ]));
  }
}

class OrderTable extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView(children: [
      Obx(() => DataTable(
            dataRowHeight: 72,
            columns: [
              
              DataColumn(label: Text('SN')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Desc')),
              DataColumn(label: Text('OriPrice')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Payment')),
            ],
            rows: [
              for (var item in controller.items)
                DataRow(cells: [
                  DataCell(Text(item.sn ?? "")),
                  DataCell(Text(item.date ?? "")),
                  DataCell(Text(item.desc ?? "")),
                  DataCell(Text("€${item.originalPrice!.toStringAsFixed(2)}")),
                  DataCell(Text("€${item.offerPrice!.toStringAsFixed(2)}")),
                  DataCell(Text(item.payment==1?"Card":"Cash")),
                ])
            ],
          ))
    ]));
  }
}

class ShopSelect extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  Widget childButton() => Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Obx(() => Text(
                    controller.shopName.value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 36,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() => MenuButton<ShopModel>(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          child: childButton(),
          items: List<ShopModel>.from(controller.shops),
          itemBuilder: (item) => Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(item.name!, style: Get.textTheme.bodyText1),
          ),
          toggledChild: Container(
            child: childButton(),
          ),
          onItemSelected: (item) => controller.selectShop(item),
        ));
  }
}
