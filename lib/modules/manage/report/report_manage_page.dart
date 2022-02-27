import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'report_manage_controller.dart';

class ReportManagePage extends GetView<ReportManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Report",
      ),
      body: Column(
        children: [
          Row(
            children: [
              DatePicker(type: "begin"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("To", style: Theme.of(context).textTheme.headline5),
              ),
              DatePicker(type: "end"),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: controller.getData,
                  child: Text("Search",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.white)))
            ],
          ),
          Container(
              color: Colors.white,
              width: context.width,
              height: context.height * 0.75,
              child: StatisticTable()),
        ],
      ),
      other: Obx(() => controller.showDetail.value ? OrderTable() : SizedBox()),
    );
  }
}

class DatePicker extends StatelessWidget {
  DatePicker({Key? key, required this.type}) : super(key: key);
  final controller = Get.find<ReportManageController>();

  final String type;

  @override
  Widget build(BuildContext context) {
    var date = type == "begin" ? controller.beginDate : controller.endDate;

    return OutlinedButton(
        child: Obx(() => Text(date.toString().split(" ")[0],
            style: Theme.of(context).textTheme.headline5)),
        onPressed: () => showDatePicker(
                    context: context,
                    initialDate: date.value,
                    firstDate: type == "begin"
                        ? DateTime.now().subtract(Duration(days: 960))
                        : controller.beginDate.value,
                    lastDate: type == "begin"
                        ? controller.endDate.value
                        : DateTime.now())
                .then((value) {
              if (value != null) {
                date(value);
              }
            }));
  }
}

class StatisticTable extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              var datarows = <DataRow>[];
              var card = 0;
              var total = 0;
              for (var i = 0; i < controller.rows.length; i++) {
                var item = controller.rows[i];
                card += item["card"] as int;
                total += item["total"] as int;
                datarows.add(DataRow(
                  selected: controller.selectedRowIndex.value == i.toString(),
                  cells: [
                    DataCell(Text(item["date"] ?? "")),
                    DataCell(Text(item["shop"] ?? "")),
                    ...controller.catalogs.map((e) => DataCell(
                          Text(
                              "€${((item[e.name] ?? 0) / 100).toStringAsFixed(2)}"),
                        )),
                    DataCell(
                        Text("€${(item["cash"] / 100).toStringAsFixed(2)}")),
                    DataCell(
                        Text("€${(item["card"] / 100).toStringAsFixed(2)}")),
                    DataCell(
                        Text("€${(item["total"] / 100).toStringAsFixed(2)}")),
                  ],
                  onSelectChanged: (value) {
                    controller.selectedRowIndex(i.toString());
                    controller.showDetail(true);
                    controller.getDetail(item["date"], item["shop"]);
                  },
                ));
              }
              if (datarows.length > 0) {
                datarows.add(DataRow(
                  cells: [
                    DataCell(Text("")),
                    DataCell(Text("")),
                    ...controller.catalogs.map((e) => DataCell(Text(""))),
                    DataCell(
                        Text("€${((total - card) / 100).toStringAsFixed(2)}")),
                    DataCell(Text("€${(card / 100).toStringAsFixed(2)}")),
                    DataCell(Text("€${(total / 100).toStringAsFixed(2)}")),
                  ],
                ));
              }
              return DataTable(
                showCheckboxColumn: false,
                dataRowHeight: 72,
                columns: controller.titles
                    .map((element) => DataColumn(label: Text(element)))
                    .toList(),
                rows: datarows,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class OrderTable extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return DialogForm(
      onWillPop: () => controller.showDetail(false),
      form: Container(
        color: Colors.white,
        width: context.width * 0.70,
        height: context.height,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Scrollbar(
          child: ListView(children: [
            Obx(() => DataTable(
                  dataRowHeight: 80,
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
                        DataCell(Text(
                            "€${(item.originalPrice! / 100).toStringAsFixed(2)}")),
                        DataCell(Text(
                            "€${(item.offerPrice! / 100).toStringAsFixed(2)}")),
                        DataCell(Text(item.payment == 1 ? "Card" : "Cash")),
                      ])
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
