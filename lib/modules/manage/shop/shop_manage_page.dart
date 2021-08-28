import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shop_manage_controller.dart';

class ShopManagePage extends GetView<ShopManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Shop Manage",
        search: (val) => controller.keywords(val),
        add: controller.add,
      ),
      body: Scrollbar(
        child: ListView(
          children: [ShopTable()],
        ),
      ),
      other: Obx(() => controller.showForm.value ? ShopForm() : SizedBox()),
    );
  }
}

class ShopTable extends StatelessWidget {
  final controller = Get.find<ShopManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.items
                .where((item) => item.name!.contains(controller.keywords)))
              DataRow(cells: [
                // DataCell(
                //     CellText((controller.items.indexOf(item) + 1).toString())),
                DataCell(Text(item.name ?? "")),
                DataCell(Text(item.address ?? "")),
                DataCell(Text(item.phone ?? "")),
                DataCell(Row(
                  children: [
                    IconButton(
                      onPressed: () => controller.edit(item.id),
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                    IconButton(
                      onPressed: () => controller.deleteConfirm(item.id),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                )),
              ])
          ],
        ));
  }
}

class ShopForm extends StatelessWidget {
  final controller = Get.find<ShopManageController>();

  @override
  Widget build(BuildContext context) {
    return DialogForm(
      onWillPop: () => controller.showForm(false),
      form: Container(
        color: Colors.white,
        width: context.width * 0.3,
        height: context.height,
        padding: EdgeInsets.all(20),
        child: Form(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Obx(() => controller.isNew.value
                //     ? Text(
                //         "Add a new shop",
                //         style: Theme.of(context).textTheme.headline4,
                //       )
                //     : SizedBox()),
                SizedBox(height: 30),
                SimpleTextField(
                  initialValue: controller.editItem.value.name,
                  labelText: "Name",
                  onChanged: (val) {
                    controller.editItem.value.name = val.trim();
                  },
                ),
                SizedBox(height: 30),
                SimpleTextField(
                  initialValue: controller.editItem.value.address,
                  labelText: "Address",
                  onChanged: (val) {
                    controller.editItem.value.address = val.trim();
                  },
                ),
                SizedBox(height: 30),
                SimpleTextField(
                  initialValue: controller.editItem.value.phone,
                  labelText: "Phone",
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    controller.editItem.value.phone = val.trim();
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
        ),
      ),
    );
  }
}
