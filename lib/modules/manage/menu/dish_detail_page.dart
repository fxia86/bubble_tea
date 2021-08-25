import 'dart:io';

import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'dish_addition_page.dart';
import 'menu_manage_controller.dart';
import 'dish_material_page.dart';
import 'dish_printer_page.dart';

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
            Container(
                width: context.width * 0.75,
                height: context.height,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryButton(category: 1),
                        Container(
                          color: Colors.black38,
                          height: 20,
                          width: 2,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        CategoryButton(category: 2),
                        Container(
                          color: Colors.black26,
                          height: 20,
                          width: 2,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        Container(
                          color: Colors.black26,
                          child: VerticalDivider(
                            color: Colors.red,
                          ),
                        ),
                        CategoryButton(category: 3),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 8, bottom: 24),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: Obx(() {
                          switch (controller.category.value) {
                            case 1:
                              return MaterialShuttle();
                            case 2:
                              return PrinterPicker();
                            case 3:
                              return AdditionSelection();
                            default:
                              return SizedBox();
                          }
                        }),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  CategoryButton({Key? key, required this.category}) : super(key: key);

  final controller = Get.find<MenuManageController>();
  final int category;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var text = "";
      switch (category) {
        case 1:
          text = "Material List";
          break;
        case 2:
          text = "Printer";
          break;
        case 3:
          text = "Addition";
          break;
        default:
      }

      final selected = controller.category.value == category;
      return Container(
        // margin: EdgeInsets.only(right: 20),
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide(color: selected ? Get.theme.primaryColor : Get.theme.backgroundColor,),),
        // ),
        child: TextButton(
            onPressed: selected ? null : () => controller.category(category),
            child: Text(
              text,
              style: Get.textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? Get.theme.primaryColor : Colors.black87),
            )),
      );
    });
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
              SizedBox(height: 20),
              CatalogSelect(),
              SizedBox(height: 20),
              SimpleTextInput(
                initialValue: controller.editItem.value.name,
                labelText: "Name",
                onChanged: (val) {
                  controller.editItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 20),
              SimpleTextInput(
                initialValue: controller.editItem.value.desc,
                labelText: "Description",
                maxline: 3,
                onChanged: (val) {
                  controller.editItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 20),
              SimpleTextInput(
                enable: enable,
                initialValue:
                    controller.editItem.value.price?.toStringAsFixed(2),
                labelText: "Price",
                suffixText: "€",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (GetUtils.isNum(val)) {
                    controller.editItem.value.price =
                        (double.parse(val) * 100).toInt();
                  }
                },
              ),
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
              SizedBox(height: 20),
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
