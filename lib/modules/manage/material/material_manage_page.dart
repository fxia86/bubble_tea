import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'material_detail_page.dart';
import 'material_manage_controller.dart';

class MaterialManagePage extends GetView<MaterialManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Left(),
                Expanded(
                  child: Column(
                    children: [
                      Top(
                        "Material Manage",
                        search: (val) => controller.keywords(val),
                        add: controller.add,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Scrollbar(
                            child: ListView(
                              children: [MaterialTable()],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => controller.showForm.value
                ? DialogForm(
                    onWillPop: () => controller.showForm(false),
                    form: MaterialForm())
                : SizedBox())
          ],
        ),
      ),
    );
  }
}

class MaterialTable extends StatelessWidget {
  final controller = Get.find<MaterialManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(
              label: Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Pic'),
              ),
            ),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Delivery Days') /* , numeric: true */),
            DataColumn(label: Text('Warning Days') /* , numeric: true */),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.items
                .where((item) => item.name!.contains(controller.keywords)))
              DataRow(cells: [
                DataCell(Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Image.network(
                    item.img!,
                    width: 80,
                  ),
                )),
                DataCell(
                  Text(item.name ?? ""),
                  // onTap: () async {
                  //   await controller.detail(item.id);
                  //   Get.dialog(MaterialDetail());
                  // },
                ),
                DataCell(Text(item.delivery.toString())),
                DataCell(Text(item.warning.toString())),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await controller.detail(item.id);
                          Get.dialog(MaterialDetail());
                        },
                        icon: Icon(Icons.view_sidebar),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () => controller.edit(item.id),
                        icon: Icon(Icons.edit),
                        color: Colors.amber,
                      ),
                      IconButton(
                        onPressed: () => controller.deleteConfirm(item.id),
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ])
          ],
        ));
  }
}
