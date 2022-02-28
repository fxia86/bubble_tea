import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:menu_button/menu_button.dart';

import 'report_manage_controller.dart';

class ReportManagePage extends GetView<ReportManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Report",
        child: Row(
          children: [
            CategoryButton(category: 1),
            Container(
              color: Get.theme.dividerColor,
              height: 20,
              width: 2,
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
            CategoryButton(category: 2),
            Container(
              color: Get.theme.dividerColor,
              height: 20,
              width: 2,
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
            CategoryButton(category: 3),
          ],
        ),
      ),
      body: Obx(() => controller.category.value == 1
          ? Column(
              children: [
                Row(
                  children: [
                    DatePicker(type: "begin"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("To",
                          style: Theme.of(context).textTheme.headline5),
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
            )
          : controller.category.value == 2
              ? Column(
                  children: [
                    Row(
                      children: [
                        DatePicker(type: "begin"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("To",
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        DatePicker(type: "end"),
                        Container(
                          width: 300,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ShopSelect(),
                        ),
                        ElevatedButton(
                            onPressed: controller.getBarChartData,
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
                        child: BarChart()),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        DatePicker(type: "line"),
                        SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: controller.getLineChartData,
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
                        child: LineChart()),
                  ],
                )),
      other: Obx(() => controller.showDetail.value ? OrderTable() : SizedBox()),
    );
  }
}

class CategoryButton extends StatelessWidget {
  CategoryButton({Key? key, required this.category}) : super(key: key);

  final controller = Get.find<ReportManageController>();
  final int category;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var text = "";
      switch (category) {
        case 1:
          text = "Report";
          break;
        case 2:
          text = "Bar Chart";
          break;
        case 3:
          text = "Line Chart";
          break;
        default:
      }

      final selected = controller.category.value == category;
      return TextButton(
          onPressed: selected ? null : () => controller.category(category),
          child: Text(
            text,
            style: Get.textTheme.headline5?.copyWith(
                fontWeight: FontWeight.w500,
                color: selected ? Get.theme.primaryColor : Colors.black87),
          ));
    });
  }
}

class DatePicker extends StatelessWidget {
  DatePicker({Key? key, required this.type}) : super(key: key);
  final controller = Get.find<ReportManageController>();

  final String type;

  @override
  Widget build(BuildContext context) {
    var date = type == "begin"
        ? controller.beginDate
        : type == "end"
            ? controller.endDate
            : controller.lineDate;

    return OutlinedButton(
        child: Obx(() => Text(date.toString().split(" ")[0],
            style: Theme.of(context).textTheme.headline5)),
        onPressed: () => showDatePicker(
                    context: context,
                    initialDate: date.value,
                    firstDate: type == "end"
                        ? controller.beginDate.value
                        : DateTime.now().subtract(Duration(days: 30)),
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

class BarChart extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        controller.barchartData.expand((element) => element.data).length > 0
            ? new charts.BarChart(controller.barchartData,
                animate: false,
                barGroupingType: charts.BarGroupingType.grouped,
                barRendererDecorator: charts.BarLabelDecorator<String>())
            : SizedBox());
  }
}

class LineChart extends StatelessWidget {
  final controller = Get.find<ReportManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.linechartData.length > 0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.linechartData
                    .map((element) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Color.fromARGB(
                            element.seriesColor!.a,
                            element.seriesColor!.r,
                            element.seriesColor!.g,
                            element.seriesColor!.b),
                        child: Text(
                          element.id,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.white),
                        )))
                    .toList(),
              ),
              Container(
                height: context.height * 0.65,
                child: new charts.LineChart(
                  controller.linechartData,
                  animate: false,
                  defaultRenderer: charts.LineRendererConfig(
                    radiusPx: 5.0,
                    includePoints: true,
                    // includeLine: true,
                  ),
                  behaviors: [
                    new charts.ChartTitle('Order QTY',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                  ],
                ),
              ),
            ],
          )
        : SizedBox());
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
