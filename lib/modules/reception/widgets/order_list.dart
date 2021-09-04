import 'package:bubble_tea/modules/reception/widgets/order_comfirm.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../reception_controller.dart';

class OrderList extends StatelessWidget {
  OrderList({Key? key}) : super(key: key);

  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Order List",
              style: Get.textTheme.headline3
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Obx(() => Scrollbar(
                  child: ListView.separated(
                    itemCount: controller.orderList.length,
                    itemBuilder: (context, index) {
                      final dish = controller.orderList[index];
                      final desc = dish.desc!.split(" + ");
                      final name = desc[0];
                      final options = desc.skip(1).join("\n");
                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child:
                                    Text(name, style: Get.textTheme.headline5),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  "€ ${(dish.offerPrice! * dish.qty! / 100).toStringAsFixed(2)}",
                                  style: Get.textTheme.headline5,
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(options,
                                      style: Get.textTheme.subtitle1),
                                ),
                                ButtonBar(
                                  buttonPadding: EdgeInsets.all(0),
                                  children: [
                                    ScaleIconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Get.theme.primaryColor,
                                      onPressed: () {
                                        if (dish.qty == 1) {
                                          controller.orderList.remove(dish);
                                        } else {
                                          final qty = dish.qty!;
                                          dish.qty = qty - 1;
                                          controller.orderList.refresh();
                                        }
                                      },
                                    ),
                                    Text(dish.qty.toString(),
                                        style: Get.textTheme.headline5),
                                    ScaleIconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      color: Get.theme.primaryColor,
                                      onPressed: () {
                                        final qty = dish.qty!;
                                        dish.qty = qty + 1;
                                        controller.orderList.refresh();
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, i) => Divider(
                      color: Colors.transparent,
                      thickness: 16,
                    ),
                    // itemExtent: 60,
                  ),
                )),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Get.theme.accentColor,
                  offset: Offset(-10, 0),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final totalPrice = controller.orderList.fold(
                      0,
                      (int previousValue, element) =>
                          previousValue + element.offerPrice! * element.qty!);
                  return Text("€ ${(totalPrice / 100).toStringAsFixed(2)}",
                      style: Get.textTheme.headline3);
                }),
                // RichText(
                //   text: TextSpan(
                //       text: "Subtotal:  ",
                //       style: Get.textTheme.subtitle1,
                //       children: [
                //         TextSpan(
                //             text: "€ ${(totalPrice / 100).toStringAsFixed(2)}",
                //             style: Get.textTheme.headline3)
                //       ]),
                // ),
                Container(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.orderList.length > 0) {
                        Get.dialog(DishConfirm());
                      }
                    },
                    child: Text("Place Order",
                        style: Get.textTheme.bodyText1
                            ?.copyWith(color: Colors.white)),
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
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
