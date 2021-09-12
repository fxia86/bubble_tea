import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_controller.dart';
import 'package:bubble_tea/utils/common_utils.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../dish_detail_controller.dart';

class AdditionSelection extends StatelessWidget {
  final controller = Get.find<DishDetailController>();

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
        initialValue: false,
        builder: (value, updateFn) {
          return Column(
            children: [
              Container(
                color: Get.theme.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "1. Select additional options",
                      style: Get.textTheme.bodyText1?.copyWith(
                          color:
                              value! ? Colors.black45 : Get.theme.primaryColor),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.navigate_next, color: Colors.black45),
                    SizedBox(width: 20),
                    Text(
                      "2. Set extra price",
                      style: Get.textTheme.bodyText1?.copyWith(
                          color:
                              value! ? Get.theme.primaryColor : Colors.black45),
                    )
                  ],
                ),
              ),
              Expanded(child: value! ? SetPriceForm() : AdditionMap()),
              value
                  ? ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateFn(false),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Get.theme.primaryColor)),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Previous',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.saveAddition,
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
                  : ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateFn(true),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Next',
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
        });
  }
}

// class AdditionMap extends StatelessWidget {
//   final controller = Get.find<DishDetailController>();
//   final parent = Get.find<MenuManageController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: parent.additions.length,
//           itemBuilder: (c, i) {
//             final addition = parent.additions[i];

//             return Container(
//               margin: EdgeInsets.only(top: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(bottom: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           color: Get.theme.primaryColor,
//                           width: 5,
//                           height: 30,
//                           margin: EdgeInsets.only(right: 10),
//                         ),
//                         Text(
//                           addition.name ?? "",
//                           style: Get.textTheme.bodyText1
//                               ?.copyWith(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Wrap(spacing: 10, children: [
//                     for (var item in addition.options)
//                       ValueBuilder<bool?>(
//                         initialValue: false,
//                         builder: (value, updateFn) {
//                           return Chip(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             label: Text(
//                               item.name ?? "",
//                               style: Get.textTheme.bodyText1,
//                             ),
//                           );
//                         },
//                         onUpdate: (value) => print('Value updated: $value'),
//                       )
//                   ]),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }

class AdditionMap extends StatelessWidget {
  final controller = Get.find<DishDetailController>();
  final parent = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: parent.additions
                .where((element) =>
                    element.catalogId == controller.editItem.value.catalogId)
                .length,
            itemBuilder: (c, i) {
              final addition = parent.additions
                  .where((element) =>
                      element.catalogId == controller.editItem.value.catalogId)
                  .elementAt(i);

              return Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            color: Get.theme.primaryColor,
                            width: 5,
                            height: 30,
                            margin: EdgeInsets.only(right: 10),
                          ),
                          Text(
                            addition.name ?? "",
                            style: Get.textTheme.bodyText1
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisExtent: 60,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: addition.options.length,
                      itemBuilder: (c, j) => Obx(() {
                        final option = addition.options[j];

                        final selected = controller.dishOptions
                            .any((element) => element.optionId == option.id);

                        return Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: selected
                                ? Get.theme.accentColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                              onPressed: () => controller.addAddition(
                                option..additionId = addition.id,
                                  addition.name, !selected),
                              child: Text(
                                option.name ?? "",
                                style: Get.textTheme.bodyText1?.copyWith(
                                    color: selected
                                        ? Get.theme.primaryColor
                                        : Colors.black87),
                              )),
                        );
                      }),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}

class SetPriceForm extends StatelessWidget {
  final controller = Get.find<DishDetailController>();
  final parent = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    final optionMap =
        groupBy(controller.dishOptions, (DishOptionModel p) => p.additionName);

    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: optionMap.length,
        itemBuilder: (c, i) {
          final selectedOptions = optionMap.values.elementAt(i);

          return Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        color: Get.theme.primaryColor,
                        width: 5,
                        height: 30,
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        optionMap.keys.elementAt(i) ?? "",
                        style: Get.textTheme.bodyText1
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedOptions.length,
                  itemExtent: 60,
                  itemBuilder: (c, j) => Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                              onPressed: null,
                              child: Text(
                                selectedOptions[j].optionName ?? "",
                                style: Get.textTheme.bodyText1,
                              )),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: MoneyTextField(
                            initialValue: selectedOptions[j].price == 0
                                ? ""
                                : "${(selectedOptions[j].price! / 100).toStringAsFixed(2)}",
                            labelText: "Extra Price",
                            onChanged: (val) {
                              selectedOptions[j].price =
                                  CommonUtils.getMoney(val);
                              controller.dishOptions.refresh();
                            },
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Obx(() {
                            final extraPrice = controller.dishOptions
                                .firstWhere((element) =>
                                    element.optionId ==
                                    selectedOptions[j].optionId)
                                .price;

                            final price =
                                controller.editItem.value.price! + extraPrice!;
                            return TextButton(
                              onPressed: null,
                              child: Text(
                                "€  ${(price / 100).toStringAsFixed(2)}",
                                style: Get.textTheme.bodyText1!.copyWith(
                                    color: extraPrice == 0
                                        ? Colors.black87
                                        : Get.theme.primaryColor),
                              ),
                            );
                          }),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 60,
                          width: 240,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigo[300])),
                            onPressed: () {
                              controller.dishOptionMaterialId(
                                  selectedOptions[j].materialId ?? "");
                              controller.dishOptionMaterialQty(
                                  selectedOptions[j].qty == 0
                                      ? 1
                                      : selectedOptions[j].qty);

                              Get.dialog(MaterialList(),
                                  arguments: selectedOptions[j].optionId);
                            },
                            child: Obx(() {
                              final materialId = controller.dishOptions
                                  .firstWhere((element) =>
                                      element.optionId == selectedOptions[j].optionId)
                                  .materialId;
                              var material = parent.materials.firstWhereOrNull(
                                  (element) => element.id == materialId);
                              return Text(
                                material == null
                                    ? "Add Material"
                                    : "${material.name} * ${selectedOptions[j].qty}",
                                style: Get.textTheme.bodyText1!
                                    .copyWith(color: Colors.white),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class MaterialList extends StatelessWidget {
  MaterialList({Key? key}) : super(key: key);
  final controller = Get.find<DishDetailController>();
  final parent = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        width: Get.width * 0.3,
        height: Get.height * 0.8,
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Available Materials",
                  style: Get.textTheme.headline5,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Get.theme.accentColor,
                child: Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: parent.materials.length,
                    itemBuilder: (c, i) => Obx(() {
                      final material = parent.materials[i];
                      final selected =
                          controller.dishOptionMaterialId.value == material.id;
                      return Container(
                        color: selected ? Colors.white : Colors.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                          onPressed: () {
                            controller.dishOptionMaterialId(
                                selected ? "" : material.id);
                            controller.dishOptionMaterialQty(1);
                          },
                          child: Text(
                            material.name!,
                            style: Get.textTheme.bodyText1?.copyWith(
                                color: selected
                                    ? Get.theme.primaryColor
                                    : Colors.black87),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() => IntegerTextField(
                    key: Key('qty_${controller.dishOptionMaterialId.value}'),
                    initialValue:
                        controller.dishOptionMaterialQty.value.toString(),
                    labelText: "Qty",
                    onChanged: (val) {
                      if (val.length > 0) {
                        controller.dishOptionMaterialQty(int.parse(val));
                      }
                    },
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                final option = controller.dishOptions
                    .firstWhere((element) => element.optionId == Get.arguments);
                if (controller.dishOptionMaterialId.value.isEmpty) {
                  option
                    ..materialId = null
                    ..qty = 0;
                } else {
                  option
                    ..materialId = controller.dishOptionMaterialId.value
                    ..qty = controller.dishOptionMaterialQty.value;
                }
                controller.dishOptions.refresh();
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
