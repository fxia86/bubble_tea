import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../reception_controller.dart';

class DishOptions extends StatelessWidget {
  DishOptions({Key? key}) : super(key: key);
  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    final DishModel item = controller.currentItem.value;

    return DialogForm(
      onWillPop: Get.back,
      form: Container(
        color: Colors.white,
        width: Get.width * 0.5,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name ?? "",
              style: Get.textTheme.headline3
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.currentOptionMap.length,
                  itemBuilder: (c, i) {
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
                                  controller.currentOptionMap.keys
                                          .elementAt(i) ??
                                      "",
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 60,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                            ),
                            itemCount:
                                controller.currentOptionMap.values.length,
                            itemBuilder: (c, j) => Obx(() {
                              final option = controller.currentOptionMap.values
                                  .elementAt(i)[j];

                              final selected = controller.currentOptions.any(
                                  (element) => element.optionId == option.optionId);
                              return Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Get.theme.accentColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: selected
                                          ? Get.theme.primaryColor
                                          : Colors.black38),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    controller.setOption(option, !selected);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        option.optionName ?? "",
                                        style: Get.textTheme.bodyText1
                                            ?.copyWith(
                                                color: selected
                                                    ? Get.theme.primaryColor
                                                    : Colors.black87),
                                      ),
                                      if (option.price != 0)
                                        Text(
                                          "€ ${(option.price! / 100).toStringAsFixed(2)}",
                                          style: Get.textTheme.bodyText1
                                              ?.copyWith(
                                                  color: selected
                                                      ? Get.theme.primaryColor
                                                      : Colors.black87),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Qty", style: Get.textTheme.headline3),
                ButtonBar(
                  children: [
                    ScaleIconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        color: Get.theme.primaryColor,
                        onPressed: () {
                          var currentQty = controller.currentQty.value;
                          if (currentQty > 1) {
                            controller.currentQty(currentQty - 1);
                          }
                        }),
                    Obx(() => Text(controller.currentQty.toString(),
                        style: Get.textTheme.headline3)),
                    ScaleIconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Get.theme.primaryColor,
                        onPressed: () {
                          var currentQty = controller.currentQty.value;
                          controller.currentQty(currentQty + 1);
                        })
                  ],
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => RichText(
                      text: TextSpan(
                          text: "Subtotal  ",
                          style: Get.textTheme.bodyText1,
                          children: [
                            TextSpan(
                                text:
                                    "€ ${(controller.currentPrice.value * controller.currentQty.value / 100).toStringAsFixed(2)}",
                                style: Get.textTheme.headline3)
                          ]),
                    )),
                Container(
                  width: 120,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.order();
                    },
                    child: Text("Order",
                        style: Get.textTheme.headline3
                            ?.copyWith(color: Colors.white)),
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
