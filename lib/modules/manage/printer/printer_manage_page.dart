import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                            Container(
                              color: Colors.white,
                              width: context.width,
                              child: PrinterTable(),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, //底部弹出时不改变页面大小
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
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        SimpleTextInput(
                          enable: false,
                          initialValue: controller.editItem.value.address,
                          labelText: "MAC Address",
                          onChanged: (val) {
                            controller.editItem.value.address = val.trim();
                          },
                        ),
                        SizedBox(height: 30),
                        SimpleTextInput(
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
    return Obx(() => DataTable(
          dataRowHeight: 72,
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Nick Name')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.items)
              DataRow(cells: [
                DataCell(Text(item.name ?? "")),
                DataCell(Text(item.address ?? "")),
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
        ));
  }
}
