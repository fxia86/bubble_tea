import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'merchant_manager_controller.dart';

class MerchantManagerPage extends GetView<MerchantManagerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Get.arguments.name} - Managers",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: controller.add,
              icon: Icon(Icons.add),
              label: Text("Add",
                  style: Get.textTheme.bodyText1?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              margin: EdgeInsets.all(24),
              child: ManagerTable(),
            ),
            Obx(() => controller.showForm.value
                ? Container(
                    child: ManagerForm(),
                  )
                : SizedBox())
          ],
        ),
      ),
    );
  }
}

class ManagerTable extends StatelessWidget {
  final controller = Get.find<MerchantManagerController>();

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

class ManagerForm extends StatelessWidget {
  final controller = Get.find<MerchantManagerController>();

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
                //         "Add a new Merchant",
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
