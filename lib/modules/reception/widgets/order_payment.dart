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
              RichText(
                  text: TextSpan(
                      text: "Total:",
                      style: Get.textTheme.bodyText1,
                      children: [
                    TextSpan(
                      text:
                          "  € ${(controller.totalAmount / 100).toStringAsFixed(2)}",
                      style: Get.textTheme.headline5,
                    )
                  ])),
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
                                      controller.totalAmount
                                  ? "  € 0.00"
                                  : "  € ${((controller.amountPaid.value - controller.totalAmount) / 100).toStringAsFixed(2)}",
                              style: Get.textTheme.headline5,
                            )
                          ]))
                    : SizedBox()),
              ),
              Container(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.payment.value == 2 &&
                        controller.amountPaid.value < controller.totalAmount) {
                      return;
                    } else{
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
