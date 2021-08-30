import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/data/models/dish_model.dart';
import 'package:bubble_tea/modules/manage/special/bundle/bundle_controller.dart';
import 'package:bubble_tea/utils/common_utils.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import '../special_manage_controller.dart';

class BundlePage extends GetView<BundleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Special offer - Bundle",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  DishList(),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: OfferList()),
                        // const Divider(),
                        DiscountForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: [
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
            )
          ],
        ),
      ),
    );
  }
}

class DishList extends StatelessWidget {
  DishList({Key? key}) : super(key: key);
  final controller = Get.find<BundleController>();

  Widget _buildDragableItem(DishModel item) {
    return Draggable<DishModel>(
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
    return Container(
      width: Get.width * 0.3,
      margin: EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available",
            style:
                Get.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: CatalogSelect(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Get.theme.accentColor,
                border: Border.all(color: Get.theme.accentColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Scrollbar(
                child: Obx(() => ListView.builder(
                      itemCount: controller.availableDishes.length,
                      itemBuilder: (c, i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                            _buildDragableItem(controller.availableDishes[i]),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
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

class CatalogSelect extends StatelessWidget {
  final _parent = Get.find<SpecialManageController>();
  final controller = Get.find<BundleController>();

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
                    controller.catalogId.value == ""
                        ? "Catalog"
                        : _parent.catalogs
                            .firstWhere((element) =>
                                element.id == controller.catalogId.value)
                            .name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.catalogId.value == ""
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
      items: _parent.catalogs.toList(),
      itemBuilder: (item) => Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(item.name!, style: Get.textTheme.bodyText1),
      ),
      toggledChild: Container(
        child: childButton(),
      ),
      onItemSelected: (item) => controller.selectCatalog(item.id),
    );
  }
}

class OfferList extends StatelessWidget {
  final _parent = Get.find<SpecialManageController>();
  final controller = Get.find<BundleController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Need",
            style:
                Get.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: DragTarget(
              builder: (a, b, c) {
                return Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.dividerColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Scrollbar(
                    child: Obx(() => ListView.builder(
                        itemCount: controller.dishes.length,
                        itemBuilder: (c, i) {
                          final dish = controller.dishes[i];
                          final price = _parent.dishes
                              .firstWhere(
                                  (element) => element.id == dish.dishId)
                              .price;
                          final total = price! * dish.qty!;
                          return Container(
                            color: Get.theme.accentColor,
                            margin: EdgeInsets.all(5),
                            height: 40,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    dish.dishName ?? "",
                                    style: Get.textTheme.bodyText1?.copyWith(
                                        color: Get.theme.primaryColor),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  "€ ${(total / 100).toStringAsFixed(2)}",
                                  style: Get.textTheme.bodyText1
                                      ?.copyWith(color: Get.theme.primaryColor),
                                ),
                                SizedBox(width: 50),
                                dish.selected
                                    ? Container(
                                        width: 60,
                                        height: 30,
                                        child: TextFormField(
                                          initialValue: dish.qty.toString(),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          autofocus: true,
                                          focusNode: controller.qtyFocusNode,
                                          onChanged: (val) {
                                            if (val.isNumericOnly) {
                                              dish.qty = int.parse(val);
                                              controller.dishes.refresh();
                                              controller.calculateTotal();
                                            }
                                          },
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          for (var item in controller.dishes) {
                                            item.selected =
                                                item.dishName == dish.dishName;
                                          }
                                          controller.dishes.refresh();
                                        },
                                        child: Text(
                                          dish.qty.toString(),
                                          style: Get.textTheme.bodyText1
                                              ?.copyWith(
                                                  color:
                                                      Get.theme.primaryColor),
                                        ),
                                      ),
                                ScaleIconButton(
                                  onPressed: () {
                                    controller.dishes.removeAt(i);
                                    controller.calculateTotal();
                                  },
                                  icon: Icon(Icons.close),
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          );
                        })),
                  ),
                );
              },
              onWillAccept: (DishModel? v) {
                // print(v?.toJson());
                return true;
              },
              onAccept: (DishModel? v) {
                if (v != null) {
                  controller.addDish(v);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class DiscountForm extends StatelessWidget {
  DiscountForm({Key? key}) : super(key: key);
  final controller = Get.find<BundleController>();
  final _parent = Get.find<SpecialManageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: Get.width * 0.2,
            child: Obx(() => MoneyTextField(
                  key: Key("bundle_total_price${controller.total.value}"),
                  enable: false,
                  initialValue: controller.total.value == 0
                      ? ""
                      : "${(controller.total.value / 100).toStringAsFixed(2)}",
                  labelText: "Total Price",
                )),
          ),
          SizedBox(width: 30),
          Container(
            width: Get.width * 0.2,
            child: MoneyTextField(
              initialValue: controller.offerPrice.value == 0
                  ? ""
                  : "${(controller.offerPrice / 100).toStringAsFixed(2)}",
              labelText: "Offer Price",
              onChanged: (val) {
                controller.offerPrice(CommonUtils.getMoney(val));
              },
            ),
          ),
        ],
      ),
    );
  }
}
