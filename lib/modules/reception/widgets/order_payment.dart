import 'package:bubble_tea/utils/common_utils.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../reception_controller.dart';

class OrderPayment extends StatelessWidget {
  OrderPayment({Key? key}) : super(key: key);
  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(child: Text("Payment", style: Get.textTheme.headline3)),
      children: [
        Container(
          width: Get.width * 0.3,
          child: Column(
            children: [
              Obx(() => RichText(
                      text: TextSpan(
                          text: "Total:",
                          style: Get.textTheme.bodyText1,
                          children: [
                        TextSpan(
                          text:
                              "  € ${(controller.totalAmount * (1 - controller.discount / 100) / 100).toStringAsFixed(2)}",
                          style: Get.textTheme.headline5
                              ?.copyWith(color: Get.theme.primaryColor),
                        )
                      ]))),
              Container(
                height: 30,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    controller.discount.value += 10;
                  },
                  child: Obx(() => Text(
                      "Discount: ${controller.discount.value}%",
                      style: Get.textTheme.headline5
                          ?.copyWith(color: Colors.white))),
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: 1,
                            groupValue: controller.payment.value,
                            onChanged: (int? v) {
                              controller.payment(v);
                              controller.amountPaid(0);
                            },
                            title: Text("Card", style: Get.textTheme.bodyText1),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 2,
                            groupValue: controller.payment.value,
                            onChanged: (int? v) {
                              controller.payment(v);
                              controller.amountPaid(0);
                            },
                            title: Text("Cash", style: Get.textTheme.bodyText1),
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => controller.payment.value == 2
                    ? MoneyTextField(
                        labelText: "Amount Paid",
                        onChanged: (val) {
                          controller.amountPaid(CommonUtils.getMoney(val));
                        },
                      )
                    : SizedBox()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Obx(() => controller.payment.value == 2
                    ? RichText(
                        text: TextSpan(
                            text: "Change:",
                            style: Get.textTheme.bodyText1,
                            children: [
                            TextSpan(
                              text: controller.amountPaid.value <
                                      controller.totalAmount * (1 - controller.discount / 100)
                                  ? "  € 0.00"
                                  : "  € ${((controller.amountPaid.value - controller.totalAmount * (1 - controller.discount / 100)) / 100).toStringAsFixed(2)}",
                              style: Get.textTheme.headline5
                                  ?.copyWith(color: Get.theme.primaryColor),
                            )
                          ]))
                    : SizedBox()),
              ),
              Container(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.payment.value == 2 &&
                        controller.amountPaid.value < controller.totalAmount * (1 - controller.discount / 100)) {
                      return;
                    } else {
                      Get.back();
                      controller.placeOrder();
                    }
                  },
                  child: Text("Place Order",
                      style: Get.textTheme.headline5
                          ?.copyWith(color: Colors.white)),
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
