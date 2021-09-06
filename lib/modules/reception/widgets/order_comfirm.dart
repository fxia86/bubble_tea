import 'package:bubble_tea/data/models/order.dart';
import 'package:bubble_tea/modules/reception/widgets/order_payment.dart';
import 'package:bubble_tea/utils/common_utils.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../reception_controller.dart';

class DishConfirm extends StatelessWidget {
  DishConfirm({Key? key}) : super(key: key);

  final controller = Get.find<ReceptionController>();

  Tuple3<List<dynamic>, int, int> getConfirmList() {
    List<OrderDishModel> list = List.from(controller.orderList
        .map((element) => OrderDishModel.copyWith(element)));

    var confirmList = [];
    var totalAmount = 0;
    var discountAmount = 0;

    //bundle
    controller.specialBundles.forEach((bundle) {
      var needed = true;
      while (needed) {
        var bundleList = <OrderDishModel>[];

        var bundleName = bundle.dishes.map((e) => e.dishName).join(", ");

        for (var item in bundle.dishes) {
          var idx = list.indexWhere((element) => element.dishId == item.dishId);
          if (idx == -1) {
            break;
          }

          var dish = OrderDishModel.copyWith(list[idx]);

          if (dish.qty! >= item.qty!) {
            dish
              ..specialOffer = "Bundle ($bundleName)"
              ..qty = item.qty
              ..originalPrice = (dish.originalPrice!).toInt()
              ..offerPrice = bundle.offerPrice;

            bundleList.add(dish);
          }
        }

        // bundle founded
        if (bundle.dishes.length == bundleList.length) {
          confirmList.add(bundleList);

          // remove bundle items from list
          bundleList.forEach((element) {
            var dish = list.firstWhere((d) => d.dishId == element.dishId);
            dish.qty = dish.qty! - element.qty!;
            if (dish.qty! == 0) {
              list.remove(dish);
            }
          });

          totalAmount += bundle.offerPrice!;
          discountAmount += bundleList.fold(
                  0,
                  (int? previousValue, element) =>
                      previousValue! + element.originalPrice! * element.qty!) -
              bundle.offerPrice!;
        } else {
          needed = false;
        }
      }
    });

    var discountList = [];
    var priceList = [];
    var normalList = [];

    list.forEach((element) {
      var discountIdx = controller.specialDiscounts
          .indexWhere((d) => d.dishId == element.dishId);
      if (discountIdx > -1) {
        if (element.qty! > 1) {
          // buy 1 get 1 discount
          var qty = element.qty! ~/ 2;
          var discount = controller.specialDiscounts[discountIdx].discount!;
          var first = OrderDishModel.copyWith(element)
            ..qty = element.qty! - qty;

          var second = OrderDishModel.copyWith(element)
            ..offerPrice =
                (element.originalPrice! * (1 - discount / 100)).toInt()
            ..qty = qty
            ..specialOffer = "Buy 1 get 1 $discount% discount";

          discountList.add([first, second]);

          totalAmount += first.originalPrice! * first.qty!;
          totalAmount += second.offerPrice! * second.qty!;

          discountAmount +=
              (second.originalPrice! - second.offerPrice!) * second.qty!;
        } else {
          // normal
          normalList.add([element]);
          totalAmount += element.offerPrice! * element.qty!;
        }
      } else {
        var priceIndex = controller.specialPrices
            .indexWhere((p) => p.dishId == element.dishId);
        if (priceIndex > -1 &&
            CommonUtils.toDateTime(controller.specialPrices[priceIndex].start!)
                .isBefore(DateTime.now()) &&
            CommonUtils.toDateTime(controller.specialPrices[priceIndex].end!)
                .isAfter(DateTime.now())) {
          // special price
          priceList.add([
            element
              ..offerPrice = controller.specialPrices[priceIndex].offerPrice!
              ..specialOffer = "Special Price"
          ]);

          totalAmount += element.offerPrice! * element.qty!;

          discountAmount +=
              (element.originalPrice! - element.offerPrice!) * element.qty!;
        } else {
          // normal
          normalList.add([element]);
          totalAmount += element.offerPrice! * element.qty!;
        }
      }
    });

    confirmList.addAll(discountList);
    confirmList.addAll(priceList);
    confirmList.addAll(normalList);

    return Tuple3(confirmList, totalAmount, discountAmount);
  }

  @override
  Widget build(BuildContext context) {
    final tuple = getConfirmList();
    final confirmList = tuple.item1;
    final totalAmount = tuple.item2;
    final discountAmount = tuple.item3;

    controller.confirmList = confirmList;
    controller.totalAmount = totalAmount;

    return DialogForm(
      onWillPop: Get.back,
      form: Container(
        color: Colors.white,
        width: Get.width * 0.75,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        "Item",
                        style: Get.textTheme.headline3,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.1,
                    child: Text(
                      "Qty",
                      style: Get.textTheme.headline3,
                    ),
                  ),
                  Container(
                    width: Get.width * 0.15,
                    child: Text(
                      "Price",
                      style: Get.textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: confirmList.length,
                  separatorBuilder: (context, i) => Divider(
                    color: Colors.transparent,
                    thickness: 16,
                  ),
                  itemBuilder: (c, i) {
                    List<OrderDishModel> items = confirmList[i];

                    final specialOffer = items
                        .firstWhere((element) => element.specialOffer != null,
                            orElse: () => items[0])
                        .specialOffer;

                    var subDiscount = 0;
                    var subtotal = 0;
                    if (specialOffer == null ||
                        specialOffer == "Special Price") {
                      subtotal = items[0].offerPrice! * items[0].qty!;

                      subDiscount =
                          (items[0].originalPrice! - items[0].offerPrice!) *
                              items[0].qty!;
                    } else if (specialOffer.contains("Bundle")) {
                      subtotal = items[0].offerPrice!;
                      subDiscount = items.fold(
                              0,
                              (int? previousValue, element) =>
                                  previousValue! +
                                  element.originalPrice! * element.qty!) -
                          subtotal;
                    } else {
                      subtotal = items[0].originalPrice! * items[0].qty! +
                          items[1].offerPrice! * items[1].qty!;
                      subDiscount =
                          (items[1].originalPrice! - items[1].offerPrice!) *
                              items[1].qty!;
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Get.theme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemExtent: 80,
                            itemBuilder: (c, j) {
                              OrderDishModel item = items[j];
                              final dish = controller.dishes.firstWhere(
                                  (element) => element.id == item.dishId);

                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Get.theme.backgroundColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        dish.img!,
                                        width: 88,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dish.name ?? "",
                                            style: Get.textTheme.headline5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            item.desc!
                                                .split(" + ")
                                                .skip(1)
                                                .join(" ,  "),
                                            style: Get.textTheme.subtitle1,
                                          )
                                        ],
                                      ),
                                    )),
                                    Container(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        item.qty.toString(),
                                        style: Get.textTheme.bodyText1,
                                      ),
                                    ),
                                    if (specialOffer == null)
                                      Container(
                                        width: Get.width * 0.15,
                                        child: Text(
                                          "€ ${(item.offerPrice! / 100).toStringAsFixed(2)}",
                                          style: Get.textTheme.headline5,
                                        ),
                                      )
                                    else if (specialOffer.contains("Bundle"))
                                      Container(
                                        width: Get.width * 0.15,
                                        child: Text(
                                          "€ ${(item.originalPrice! / 100).toStringAsFixed(2)}",
                                          style: Get.textTheme.subtitle1!
                                              .copyWith(
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        ),
                                      )
                                    else if (specialOffer.contains("discount"))
                                      Container(
                                        width: Get.width * 0.15,
                                        child: item.specialOffer == null
                                            ? Text(
                                                "€ ${(item.originalPrice! / 100).toStringAsFixed(2)}",
                                                style: Get.textTheme.headline5,
                                              )
                                            : RichText(
                                                text: TextSpan(
                                                    text:
                                                        "€ ${(item.offerPrice! / 100).toStringAsFixed(2)} ",
                                                    style: Get
                                                        .textTheme.bodyText1!,
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "€ ${(item.originalPrice! / 100).toStringAsFixed(2)}",
                                                          style: Get.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough))
                                                    ]),
                                              ),
                                      )
                                    else
                                      Container(
                                        width: Get.width * 0.15,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "€ ${(item.offerPrice! / 100).toStringAsFixed(2)} ",
                                              style: Get.textTheme.bodyText1!,
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "€ ${(item.originalPrice! / 100).toStringAsFixed(2)}",
                                                    style: Get
                                                        .textTheme.subtitle1!
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                              ]),
                                        ),
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                          Divider(thickness: 1.5, indent: 120),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                if (specialOffer != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF5128),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      specialOffer.contains("Bundle")
                                          ? "Bundle"
                                          : specialOffer,
                                      style: Get.textTheme.subtitle1
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (specialOffer != null)
                                  Text(
                                    "Discount",
                                    style: Get.textTheme.bodyText1,
                                  ),
                                SizedBox(
                                  width: 5,
                                ),
                                if (specialOffer != null)
                                  Text(
                                    "€ ${(subDiscount / 100).toStringAsFixed(2)}",
                                    style: Get.textTheme.headline5?.copyWith(
                                      color: Color(0xFFFF5128),
                                    ),
                                  ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Subtotal",
                                  style: Get.textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: Get.width * 0.15,
                                  child: Text(
                                    "€ ${(subtotal / 100).toStringAsFixed(2)}",
                                    style: Get.textTheme.headline5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Discount ",
                    style: Get.textTheme.headline5,
                  ),
                  Text(
                    "€ ${(discountAmount / 100).toStringAsFixed(2)}",
                    style: Get.textTheme.headline3?.copyWith(
                      color: Color(0xFFFF5128),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Total ",
                    style: Get.textTheme.headline5,
                  ),
                  Text(
                    " € ${(totalAmount / 100).toStringAsFixed(2)}",
                    style: Get.textTheme.headline3,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.dialog(OrderPayment());
                      },
                      child: Text("Order",
                          style: Get.textTheme.headline3
                              ?.copyWith(color: Colors.white)),
                      style:
                          ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
