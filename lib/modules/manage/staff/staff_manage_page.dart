import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'staff_manage_controller.dart';

class StaffManagePage extends GetView<StaffManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Staff Manage",
        search: (val) => controller.keywords(val),
        add: controller.add,
      ),
      body: Scrollbar(
        child: ListView(
          children: [StaffTable()],
        ),
      ),
      other: Obx(() => controller.showForm.value ? StaffForm() : SizedBox()),
    );
  }
}

class StaffTable extends StatelessWidget {
  final controller = Get.find<StaffManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Shop')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.items
                .where((item) => item.name!.contains(controller.keywords)))
              DataRow(cells: [
                DataCell(Text(item.name ?? "")),
                DataCell(Text(item.email ?? "")),
                DataCell(Text(item.phone ?? "")),
                DataCell(Text(item.shopName ?? "")),
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

class StaffForm extends StatelessWidget {
  final controller = Get.find<StaffManageController>();

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
                ShopSelect(),
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

class ShopSelect extends StatelessWidget {
  final controller = Get.find<StaffManageController>();

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
      // onMenuButtonToggle: (bool isToggle) {
      //   print(isToggle);
      // },
    );
  }
}
