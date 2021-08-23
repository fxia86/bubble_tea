import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'printer_manage_controller.dart';

class PrinterManagePage extends GetView<PrinterManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Left(),
            Expanded(
              child: Column(
                children: [
                  Top(
                    "Printer Manage",
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                                color: Colors.white,
                                width: context.width,
                                height: context.height * 0.35,
                                child: PrinterForm()),
                            SizedBox(height: 24),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                width: context.width,
                                child: PrinterTable(),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrinterForm extends StatelessWidget {
  final controller = Get.find<PrinterManageController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.width * 0.4,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      "Paired Printers",
                      style: Get.textTheme.headline5,
                    ),
                    IconButton(
                      onPressed: controller.initPrinters,
                      icon: Icon(
                        Icons.refresh,
                        color: Get.theme.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: Obx(() => ListView(
                        children: [
                          for (var index = 0;
                              index < controller.pairedPrinters.length;
                              index++)
                            RadioListTile(
                              value: index + 1,
                              groupValue: controller.radioValue.value,
                              onChanged: (int? val) {
                                controller.radioValue(val);
                              },
                              title: Text(
                                controller.pairedPrinters[index].name ?? "",
                                style: controller.radioValue.value == index + 1
                                    ? Get.textTheme.bodyText1?.copyWith(
                                        color: Get.theme.primaryColor)
                                    : Get.textTheme.bodyText1,
                              ),
                              subtitle: Text(
                                controller.pairedPrinters[index].address ?? "",
                                style: controller.radioValue.value == index + 1
                                    ? Get.textTheme.subtitle1?.copyWith(
                                        color: Get.theme.primaryColor)
                                    : Get.textTheme.subtitle1,
                              ),
                              selected:
                                  controller.radioValue.value == index + 1,
                            )
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
        VerticalDivider(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Obx(() => Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        // SimpleTextInput(
                        //   key: Key('address_${controller.radioValue}'),
                        //   enable: false,
                        //   initialValue: controller.editItem.value.address,
                        //   labelText: "MAC Address",
                        //   onChanged: (val) {
                        //     controller.editItem.value.address = val.trim();
                        //   },
                        // ),
                        ShopSelect(),
                        SizedBox(height: 30),
                        SimpleTextInput(
                          key: Key('alias_${controller.radioValue}'),
                          initialValue: controller.editItem.value.alias,
                          labelText: "Nick Name",
                          onChanged: (val) {
                            controller.editItem.value.alias = val.trim();
                          },
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: controller.save,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

class PrinterTable extends StatelessWidget {
  final controller = Get.find<PrinterManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView(children: [
      Obx(() => DataTable(
            dataRowHeight: 72,
            columns: [
              DataColumn(label: Text('Printer')),
              DataColumn(label: Text('Shop')),
              DataColumn(label: Text('Nick Name')),
              DataColumn(label: Text('')),
            ],
            rows: [
              for (var item in controller.items)
                DataRow(cells: [
                  DataCell(Text(item.name ?? "")),
                  DataCell(Text(item.shopName ?? "")),
                  DataCell(Text(item.alias ?? "")),
                  DataCell(
                    IconButton(
                      onPressed: () => controller.deleteConfirm(item.id),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ])
            ],
          ))
    ]));
  }
}

class ShopSelect extends StatelessWidget {
  final controller = Get.find<PrinterManageController>();

  Widget childButton() => Container(
        height: 60,
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
                    controller.editItem.value.shopName ?? "Shop",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.editItem.value.shopId == null
                            ? Colors.grey
                            : Colors.black),
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
    return MenuButton<ShopModel>(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      child: childButton(),
      items: controller.shops,
      itemBuilder: (item) => Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(item.name!, style: Get.textTheme.bodyText1),
      ),
      toggledChild: Container(
        child: childButton(),
      ),
      onItemSelected: (item) => controller.selectShop(item),
    );
  }
}
