import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_manage_controller.dart';

class PrinterPicker extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.printerMap.length,
          itemBuilder: (c, i) {
            final String shop = controller.printerMap.keys.elementAt(i);
            final List<PrinterModel> printers =
                controller.printerMap.values.elementAt(i);

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
                        return Container(
                          child: ValueBuilder<bool?>(
                            initialValue: false,
                            builder: (value, updateFn) => CheckboxListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: Text(printers[j].alias ?? "",
                                  style: Get.textTheme.bodyText1),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: value,
                              onChanged: (v) => updateFn(v!),
                            ),
                            onUpdate: (value) => print('Value updated: $value'),
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
