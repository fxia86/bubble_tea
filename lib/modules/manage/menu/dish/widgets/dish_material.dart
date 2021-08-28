import 'package:bubble_tea/data/models/material_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../menu_manage_controller.dart';
import '../dish_detail_controller.dart';

class MaterialSelection extends StatelessWidget {
  final controller = Get.find<DishDetailController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MaterialShuttle(),
        ),
        ButtonBar(
          children: [
            ElevatedButton(
              onPressed: controller.saveMaterial,
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
        )
      ],
    );
  }
}

class MaterialShuttle extends StatelessWidget {
  final controller = Get.find<DishDetailController>();
  final parent = Get.find<MenuManageController>();

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
                      itemCount: parent.materials.length,
                      itemBuilder: (c, i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _buildDragableItem(parent.materials[i]),
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
                                              style: Get.textTheme.bodyText1
                                                  ?.copyWith(
                                                      color: Get
                                                          .theme.primaryColor),
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
