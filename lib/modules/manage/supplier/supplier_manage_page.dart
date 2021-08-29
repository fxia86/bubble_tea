import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'supplier_manage_controller.dart';

class SupplierManagePage extends GetView<SupplierManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Supplier Manage",
        search: (val) => controller.keywords(val),
        add: controller.add,
      ),
      body: Scrollbar(
        child: ListView(
          children: [SupplierTable()],
        ),
      ),
      other: Obx(() => controller.showForm.value ? SupplierForm() : SizedBox()),
    );
  }
}

class SupplierTable extends StatelessWidget {
  final controller = Get.find<SupplierManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.items
                .where((item) => item.name!.contains(controller.keywords)))
              DataRow(cells: [
                DataCell(Text(item.name ?? "")),
                DataCell(Text(item.email ?? "")),
                DataCell(Text(item.phone ?? "")),
                DataCell(Row(
                  children: [
                    ScaleIconButton(
                      onPressed: () => controller.edit(item.id),
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                    ScaleIconButton(
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

class SupplierForm extends StatelessWidget {
  final controller = Get.find<SupplierManageController>();

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
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                  initialValue: controller.editItem.value.email,
                  labelText: "Email",
                  onChanged: (val) {
                    controller.editItem.value.email = val.trim();
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
