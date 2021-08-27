import 'dart:io';

import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/models/supplier_model.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'material_manage_controller.dart';

class MaterialDetail extends StatelessWidget {
  MaterialDetail({Key? key}) : super(key: key);

  final controller = Get.find<MaterialManageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Materail Detail",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            MaterialForm(enable: false),
            Container(
              width: context.width * 0.75,
              height: context.height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stock Map",
                    style: Get.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: context.height * 0.3,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 15, bottom: 25),
                    child: Scrollbar(
                      child: Obx(
                        () => ListView(
                          children: [
                            for (var item in controller.stocks)
                              ListTile(
                                title: Text(
                                  item.shopName ?? "",
                                  style: Get.textTheme.bodyText1,
                                ),
                                trailing: Text(item.qty.toString(),
                                    style: Get.textTheme.bodyText1),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stock Map",
                        style: Get.textTheme.headline5
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: Get.height * 0.052,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.initOrder();
                            Get.dialog(OrderForm());
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add",
                              style: Get.textTheme.bodyText1?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      color: Colors.white,
                      child: StockTable(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MaterialForm extends StatelessWidget {
  MaterialForm({Key? key, this.enable = true}) : super(key: key);

  final controller = Get.find<MaterialManageController>();
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: context.width * (enable ? 0.3 : 0.25),
      height: context.height,
      padding: EdgeInsets.all(20),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImagePickerBox(enable: enable),
              SizedBox(height: 30),
              SimpleTextInput(
                enable: enable,
                initialValue: controller.editItem.value.name,
                labelText: "Name",
                onChanged: (val) {
                  controller.editItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 30),
              SimpleTextInput(
                enable: enable,
                initialValue: controller.editItem.value.delivery?.toString(),
                labelText: "Delivery Days",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (GetUtils.isNumericOnly(val)) {
                    controller.editItem.value.delivery = int.parse(val);
                  }
                },
              ),
              SizedBox(height: 30),
              SimpleTextInput(
                enable: enable,
                initialValue: controller.editItem.value.warning?.toString(),
                labelText: "Warning Days",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (GetUtils.isNumericOnly(val)) {
                    controller.editItem.value.warning = int.parse(val);
                  }
                },
              ),
              SizedBox(height: 30),
              if (enable)
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
    );
  }
}

class ImagePickerBox extends StatelessWidget {
  ImagePickerBox({Key? key, this.enable = true}) : super(key: key);

  final controller = Get.find<MaterialManageController>();
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Obx(() => controller.imagePath.isNotEmpty
            ? Image.file(File(controller.imagePath.value))
            : controller.editItem.value.img != null
                ? Image.network(controller.editItem.value.img!)
                : Icon(Icons.add_a_photo)),
      ),
      onTap: enable
          ? () => Get.dialog(
                SimpleDialog(
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.pickImage(0);
                          },
                          child: Text(
                            "Pick image from gallery",
                            style: Get.textTheme.headline5
                                ?.copyWith(color: Get.theme.primaryColor),
                          ),
                        ),
                        Divider(thickness: 1),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.pickImage(1);
                          },
                          child: Text(
                            "Take a photo",
                            style: Get.textTheme.headline5
                                ?.copyWith(color: Get.theme.primaryColor),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          : null,
    );
  }
}

class StockTable extends StatelessWidget {
  final controller = Get.find<MaterialManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Obx(() => DataTable(
                columns: [
                  // DataColumn(label: Text('Order Date')),
                  DataColumn(label: Text('Arrived Date')),
                  DataColumn(label: Text('QTY')),
                  DataColumn(label: Text('Supplier')),
                  DataColumn(label: Text('Shop')),
                ],
                rows: [
                  for (var item in controller.stockOrders)
                    DataRow(cells: [
                      // DataCell(Text(item.orderDate??"")),
                      DataCell(Text(item.arrivedDate ?? "")),
                      DataCell(Text(item.qty.toString())),
                      DataCell(Text(item.supplierName ?? "")),
                      DataCell(Text(item.shopName ?? "")),
                    ])
                ],
              )),
        ],
      ),
    );
  }
}

class OrderForm extends StatelessWidget {
  final controller = Get.find<MaterialManageController>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          width: context.width * 0.3,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              ShopSelect(),
              SizedBox(height: 30),
              SupplierSelect(),
              SizedBox(height: 30),
              SimpleTextInput(
                initialValue: controller.newOrder.value.qty?.toString(),
                labelText: "QTY",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (GetUtils.isNumericOnly(val)) {
                    controller.newOrder.value.qty = int.parse(val);
                  }
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (controller.newOrder.value.qty == null ||
                      controller.newOrder.value.qty! <= 0) {
                    return;
                  }
                  await controller.addOrder();
                },
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
              )
            ],
          ),
        )
      ],
    );
  }
}

class ShopSelect extends StatelessWidget {
  final controller = Get.find<MaterialManageController>();

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
                    controller.newOrder.value.shopName ?? "Shop",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.newOrder.value.shopId == null
                            ? Colors.black54
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

class SupplierSelect extends StatelessWidget {
  final controller = Get.find<MaterialManageController>();

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
                    controller.newOrder.value.supplierName ?? "Supplier",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.newOrder.value.supplierId == null
                            ? Colors.black54
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
    return MenuButton<SupplierModel>(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      child: childButton(),
      items: controller.suppliers,
      itemBuilder: (item) => Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(item.name!, style: Get.textTheme.bodyText1),
      ),
      toggledChild: Container(
        child: childButton(),
      ),
      onItemSelected: (item) => controller.selectSupplier(item),
    );
  }
}
