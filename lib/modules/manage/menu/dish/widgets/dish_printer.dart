import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../menu_manage_controller.dart';
import '../dish_detail_controller.dart';

class PrinterSelection extends StatelessWidget {
  final controller = Get.find<DishDetailController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PrinterPicker(),
        ),
        ButtonBar(
          children: [
            ElevatedButton(
              onPressed: controller.savePrinter,
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
        )
      ],
    );
  }
}

class PrinterPicker extends StatelessWidget {
  final controller = Get.find<DishDetailController>();
  final parent = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: parent.printerMap.length,
          itemBuilder: (c, i) {
            final String shop = parent.printerMap.keys.elementAt(i);
            final List<PrinterModel> printers =
                parent.printerMap.values.elementAt(i);

            return Container(
              margin: EdgeInsets.only(top: 8, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop,
                    style: Get.textTheme.bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         shrinkWrap: true,
                  //         itemCount: printers.length,
                  //         itemBuilder: (c, j) {
                  //           return Container(
                  //             width: 200,
                  //             margin: EdgeInsets.only(right: 15),
                  //             child: ValueBuilder<bool?>(
                  //               initialValue: false,
                  //               builder: (value, updateFn) => CheckboxListTile(
                  //                 contentPadding: EdgeInsets.only(left: 0),
                  //                 title: Text(printers[j].alias ?? "",
                  //                     style: Get.textTheme.bodyText1),
                  //                 controlAffinity:
                  //                     ListTileControlAffinity.leading,
                  //                 value: value,
                  //                 onChanged: (v) => updateFn(v!),
                  //               ),
                  //               onUpdate: (value) =>
                  //                   print('Value updated: $value'),
                  //             ),
                  //           );
                  //         }),
                  //   ),
                  // ),
                  GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, mainAxisExtent: 50),
                      itemCount: printers.length,
                      itemBuilder: (c, j) {
                        final printer = printers[j];

                        final selected = controller.dishPrinters
                            .any((element) => element.printerId == printer.id);

                        return Container(
                          child: ValueBuilder<bool?>(
                            initialValue: selected,
                            builder: (value, updateFn) => CheckboxListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: Text(printer.alias ?? "",
                                  style: Get.textTheme.bodyText1),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: value,
                              onChanged: (v) => updateFn(v!),
                            ),
                            onUpdate: (value) =>
                                controller.addPrinter(printer.id, value!),
                          ),
                        );
                      }),
                  Divider()
                ],
              ),
            );
          }),
    );
  }
}
