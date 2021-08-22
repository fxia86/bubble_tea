import 'dart:io';

import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/widgets/cell_text.dart';
import 'package:bubble_tea/widgets/navi_bar.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'menu_manage_controller.dart';

class MenuManagePage extends GetView<MenuManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Menu Manage"),
          actions: [
            IconButton(
              onPressed: () {
                controller.add();
                Get.dialog(DishDetail(title: ""));
              },
              icon: Icon(Icons.add),
              iconSize: 30,
            )
          ],
          bottom: PreferredSize(
              child: Obx(
                () => TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  labelStyle: Theme.of(context).textTheme.headline5,
                  // indicatorColor: Colors.white,
                  unselectedLabelStyle: Theme.of(context).textTheme.headline6,
                  indicatorWeight: 3,
                  tabs: [
                    for (var item in controller.catalogs) Tab(text: item.name)
                  ],
                ),
              ),
              preferredSize: Size(Get.width, 50))),
      drawer: Drawer(
        child: NaviBar(),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          for (var _ in controller.catalogs)
            MenuGrid(list: controller.items, crossAxisCount: 3)
        ],
      ),
    );
  }
}

class MenuGrid extends StatelessWidget {
  MenuGrid({Key? key, required this.list, this.crossAxisCount = 2})
      : super(key: key);

  final list;
  final crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.5,
      padding: EdgeInsets.all(20),
      children: [for (var item in list) MenuItem(item: item)],
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({Key? key, required this.item}) : super(key: key);

  final controller = Get.find<MenuManageController>();

  final item;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          item.picture,
          fit: BoxFit.cover,
        ),
      ),
      footer: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
        clipBehavior: Clip.antiAlias,
        child: GridTileBar(
          backgroundColor: Colors.black45,
          title: MenuItemTitle(
              text:
                  "${item.materialName}     € ${(item.price / 100).toStringAsFixed(2)}",
              fontSize: 28),
          subtitle: 1 == 1 ? MenuItemTitle(text: item.desc) : null,
          trailing: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              size: 32,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class MenuItemTitle extends StatelessWidget {
  const MenuItemTitle({Key? key, required this.text, this.fontSize = 20})
      : super(key: key);
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class DishDetail extends StatelessWidget {
  DishDetail({Key? key, required this.title}) : super(key: key);
  final controller = Get.find<MenuManageController>();
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dish Detail"),
        actions: [
          IconButton(
            onPressed: controller.save,
            icon: Icon(Icons.save),
            iconSize: 30,
          ),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            Material(elevation: 10, child: DishForm()),
            SizedBox(width: 10),
            Material(elevation: 10, child: MaterialShuttle()),
            SizedBox(width: 10),
            Expanded(
              child: Material(
                elevation: 10,
                child: OptionalForm(),
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
      width: context.width * 0.3,
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
                    title: CellText("Popular List"),
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
          // color: Colors.red,
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
                  child: CellText("Pick image from gallery"),
                ),
                Divider(),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.pickImage(1);
                  },
                  child: CellText("Take a photo"),
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
        child: Text(item.name!, style: TextStyle(fontSize: 20)),
      ),
      toggledChild: Container(
        child: childButton(),
      ),
      onItemSelected: (item) => controller.selectCatalog(item),
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
      child: Container(
        child: ListTile(
          title: CellText(item.name),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        child: ListTile(
          title: CellText(item.name),
        ),
      ),
      feedback: Container(
        color: Get.theme.primaryColor,
        width: Get.width * 0.2,
        height: 60,
        child: ListTile(
          title: CellText(item.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CellText("Material List", fontSize: 24),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      CellText("Available"),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Scrollbar(
                            child: ListView.builder(
                              itemCount: controller.materials.length,
                              itemBuilder: (c, i) => Padding(
                                padding: EdgeInsets.only(right: 40),
                                child:
                                    _buildDragableItem(controller.materials[i]),
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
                    children: [
                      CellText("Need"),
                      SizedBox(height: 20),
                      Expanded(
                        child: DragTarget(
                          builder: (a, b, c) {
                            return Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Scrollbar(
                                child: Obx(() => ListView.builder(
                                      itemCount:
                                          controller.dishMaterials.length,
                                      itemBuilder: (c, i) => ListTile(
                                        title: InkWell(
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: CellText(controller
                                                .dishMaterials[i].materialName),
                                          ),
                                          highlightColor: Colors.blue[100],
                                          onLongPress: () =>
                                              controller.removeMaterial(i),
                                        ),
                                        trailing: Obx(() => controller
                                                .dishMaterials[i].selected
                                            ? Container(
                                                width: 60,
                                                child: TextFormField(
                                                  initialValue: controller
                                                      .dishMaterials[i].qty
                                                      .toString(),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autofocus: true,
                                                  // focusNode:
                                                  //     controller.qtyFocusNode,
                                                  onChanged: (val) {},
                                                  onEditingComplete: () {},
                                                  onFieldSubmitted: (val) {
                                                    if (GetUtils.isNumericOnly(
                                                        val)) {
                                                      controller
                                                          .dishMaterials[i]
                                                          .qty = int.parse(val);
                                                      controller
                                                          .dishMaterials[i]
                                                          .selected = false;
                                                      controller.dishMaterials
                                                          .refresh();
                                                    }
                                                  },
                                                  onSaved: (val) {},
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  for (var item in controller
                                                      .dishMaterials) {
                                                    item.selected = item
                                                            .materialName ==
                                                        controller
                                                            .dishMaterials[i]
                                                            .materialName;
                                                  }
                                                  controller.dishMaterials
                                                      .refresh();
                                                },
                                                child: CellText(controller
                                                    .dishMaterials[i].qty
                                                    .toString()),
                                              )),
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
            ),
          )
        ],
      ),
    );
  }
}

class OptionalForm extends StatelessWidget {
  final controller = Get.find<MenuManageController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: context.height,
      padding: EdgeInsets.all(20),
      child: Text("data"),
    );
  }
}
