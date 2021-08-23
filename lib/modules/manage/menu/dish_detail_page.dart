import 'dart:io';

import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/printer_model.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'menu_manage_controller.dart';

class DishDetail extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dish Detail",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: controller.save,
            icon: Icon(Icons.save),
            iconSize: 30,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            DishForm(),
            // SizedBox(width: 10),
            Container(
              width: context.width * 0.75,
              height: context.height,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Material List",
                    style: Get.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Container(
                    width: Get.width,
                    height: Get.height * 0.32,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: MaterialShuttle(),
                  ),
                  Text(
                    "Printer",
                    style: Get.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      child: PrinterPicker(),
                    ),
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

class DishForm extends StatelessWidget {
  DishForm({Key? key, this.enable = true}) : super(key: key);

  final controller = Get.find<MenuManageController>();
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: context.width * 0.25,
      height: context.height,
      padding: EdgeInsets.all(20),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImagePickerBox(),
              SizedBox(height: 30),
              CatalogSelect(),
              SizedBox(height: 30),
              SimpleTextInput(
                initialValue: controller.editItem.value.name,
                labelText: "Name",
                onChanged: (val) {
                  controller.editItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 30),
              SimpleTextInput(
                initialValue: controller.editItem.value.desc,
                labelText: "Description",
                maxline: 3,
                onChanged: (val) {
                  controller.editItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 30),
              SimpleTextInput(
                enable: enable,
                initialValue:
                    controller.editItem.value.price?.toStringAsFixed(2),
                labelText: "Price",
                suffixText: "€",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (GetUtils.isNum(val)) {
                    controller.editItem.value.price = int.parse(val) * 100;
                  }
                },
              ),
              SizedBox(height: 20),
              Obx(() => CheckboxListTile(
                    contentPadding: EdgeInsets.only(left: 0),
                    title: Text("Popular List", style: Get.textTheme.bodyText1),
                    value: controller.editItem.value.isPopular,
                    onChanged: (value) {
                      controller.editItem.value.isPopular = value;
                      controller.editItem.refresh();
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePickerBox extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

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
      onTap: () => Get.dialog(
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
      ),
    );
  }
}

class CatalogSelect extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

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
                    controller.editItem.value.catalogName ?? "Catalog",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.editItem.value.catalogId == null
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
    return MenuButton<CatalogModel>(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      child: childButton(),
      items: controller.catalogs.skip(1).toList(),
      itemBuilder: (item) => Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(item.name!, style: Get.textTheme.bodyText1),
      ),
      toggledChild: Container(
        child: childButton(),
      ),
      onItemSelected: (item) => controller.selectCatalog(item),
    );
  }
}

class DragItem extends StatelessWidget {
  const DragItem({Key? key, required this.text, this.color, this.width = 100})
      : super(key: key);

  final String? text;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      height: 40,
      child: Text(text ?? "", style: Get.textTheme.bodyText1),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
    );
  }
}

class MaterialShuttle extends StatelessWidget {
  MaterialShuttle({Key? key}) : super(key: key);
  final controller = Get.find<MenuManageController>();

  Widget _buildDragableItem(MaterialModel item) {
    return Draggable<MaterialModel>(
      // axis: Axis.horizontal,
      data: item,
      child: DragItem(
        text: item.name,
        // color: Colors.white,
      ),
      childWhenDragging:
          DragItem(text: item.name, color: Get.theme.backgroundColor),
      feedback: DragItem(
          text: item.name,
          color: Get.theme.accentColor,
          width: Get.width * 0.15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available",
                style: Get.textTheme.bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Get.theme.accentColor,
                    border: Border.all(color: Get.theme.accentColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: controller.materials.length,
                      itemBuilder: (c, i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _buildDragableItem(controller.materials[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Need",
                style: Get.textTheme.bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: DragTarget(
                  builder: (a, b, c) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Get.theme.dividerColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Scrollbar(
                        child: Obx(() => ListView.builder(
                              itemCount: controller.dishMaterials.length,
                              itemBuilder: (c, i) => Container(
                                color: Get.theme.accentColor,
                                margin: EdgeInsets.all(5),
                                height: 40,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        controller.dishMaterials[i]
                                                .materialName ??
                                            "",
                                        style: Get.textTheme.bodyText1
                                            ?.copyWith(
                                                color: Get.theme.primaryColor),
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Obx(() => controller
                                            .dishMaterials[i].selected
                                        ? Container(
                                            width: 60,
                                            height: 30,
                                            child: TextFormField(
                                              initialValue: controller
                                                  .dishMaterials[i].qty
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              autofocus: true,
                                              focusNode:
                                                  controller.qtyFocusNode,
                                              onChanged: (val) {
                                                if (GetUtils.isNumericOnly(
                                                    val)) {
                                                  controller.dishMaterials[i]
                                                      .qty = int.parse(val);
                                                  // controller.dishMaterials[i]
                                                  //     .selected = false;
                                                  controller.dishMaterials
                                                      .refresh();
                                                }
                                              },
                                            ),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              for (var item
                                                  in controller.dishMaterials) {
                                                item.selected =
                                                    item.materialName ==
                                                        controller
                                                            .dishMaterials[i]
                                                            .materialName;
                                              }
                                              controller.dishMaterials
                                                  .refresh();
                                            },
                                            child: Text(
                                              controller.dishMaterials[i].qty
                                                  .toString(),
                                              style: Get.textTheme.bodyText1?.copyWith(color: Get.theme.primaryColor),
                                            ),
                                          )),
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeMaterial(i),
                                      icon: Icon(Icons.close),
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    );
                  },
                  onWillAccept: (MaterialModel? v) {
                    // print(v?.toJson());
                    return true;
                  },
                  onAccept: (MaterialModel? v) {
                    if (v != null) {
                      controller.addMaterial(v);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PrinterPicker extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          itemCount: controller.printerMap.length,
          itemBuilder: (c, i) {
            final String shop = controller.printerMap.keys.elementAt(i);
            final List<PrinterModel> printers =
                controller.printerMap.values.elementAt(i);

            return Container(
              height: 80,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop,
                    style: Get.textTheme.bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: printers.length,
                          itemBuilder: (c, j) {
                            return Container(
                              width: 200,
                              margin: EdgeInsets.only(right: 15),
                              child: ValueBuilder<bool?>(
                                initialValue: false,
                                builder: (value, updateFn) => CheckboxListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text(printers[j].alias ?? "",
                                      style: Get.textTheme.bodyText1),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: value,
                                  onChanged: (v) => updateFn(v!),
                                ),
                                onUpdate: (value) =>
                                    print('Value updated: $value'),
                              ),
                            );
                          }),
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          }),
    );
  }
}
