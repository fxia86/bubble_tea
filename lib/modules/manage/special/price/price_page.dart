import 'package:bubble_tea/modules/manage/special/special_manage_controller.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'price_controller.dart';

class PricePage extends GetView<PriceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Special offer - Price",
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
                  CatalogList(),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: DishList()),
                        const Divider(),
                        PriceForm(),
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

class CatalogList extends StatelessWidget {
  CatalogList({Key? key}) : super(key: key);

  final _parent = Get.find<SpecialManageController>();
  final controller = Get.find<PriceController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Catalog",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Container(
            width: Get.width * 0.3,
            margin: EdgeInsets.only(top: 10, right: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Get.theme.accentColor,
              border: Border.all(color: Get.theme.accentColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _parent.catalogs.length,
                itemBuilder: (c, i) => Obx(() {
                  final catalog = _parent.catalogs[i];
                  final selected = catalog.id == controller.catalogId.value;
                  return InkWell(
                    onTap: () {
                      if (!selected) {
                        controller.catalogId(catalog.id);
                        controller.dishId.value = "";
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? Get.theme.primaryColor
                            : Colors.transparent,
                        // border: Border.all(color: Get.theme.accentColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(catalog.name ?? "",
                          style: Get.textTheme.bodyText1?.copyWith(
                              color: selected ? Colors.white : Colors.black87)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DishList extends StatelessWidget {
  DishList({Key? key}) : super(key: key);
  final _parent = Get.find<SpecialManageController>();
  final controller = Get.find<PriceController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Obx(() {
        final dishes = _parent.dishes
            .where((element) => element.catalogId == controller.catalogId.value)
            .toList();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 50,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          itemCount: dishes.length,
          itemBuilder: (c, i) => Obx(() {
            final dish = dishes[i];
            final selected = dish.id == controller.dishId.value;

            return Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: selected ? Get.theme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {
                  controller.dishId(dish.id);
                  controller.dishName(dish.name);
                  final idx = _parent.discounts
                      .indexWhere((element) => element.dishId == dish.id);
                  if (idx > -1) {
                    controller.offerPrice(_parent.discounts[idx].discount);
                  } else {
                    controller.offerPrice(0);
                  }
                },
                child: Text(
                  dish.name ?? "",
                  style: Get.textTheme.bodyText1?.copyWith(
                      color: selected ? Colors.white : Colors.black87),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

class PriceForm extends StatelessWidget {
  PriceForm({Key? key}) : super(key: key);
  final controller = Get.find<PriceController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Date",
                style: Get.textTheme.bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                rangeSelectionColor: Get.theme.accentColor,
                startRangeSelectionColor: Get.theme.primaryColor,
                endRangeSelectionColor: Get.theme.primaryColor,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    final DateTime rangeStartDate = args.value.startDate;
                    final DateTime rangeEndDate = args.value.endDate;
                  } else if (args.value is DateTime) {
                    final DateTime selectedDate = args.value;
                  } else if (args.value is List<DateTime>) {
                    final List<DateTime> selectedDates = args.value;
                  } else {
                    final List<PickerDateRange> selectedRanges = args.value;
                  }
                },
                initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(Duration(days: 4)),
                  DateTime.now().add(Duration(days: 3)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 50),
        Container(
          width: Get.width * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoneyTextField(
                key: Key('originPrice_${controller.dishId}'),
                enable: false,
                initialValue: controller.offerPrice.toString(),
                labelText: "Original Price",
                onChanged: (val) {
                  controller.offerPrice(int.parse(val));
                },
              ),
              SizedBox(height: 50),
              Obx(() => MoneyTextField(
                    key: Key('price_${controller.dishId}'),
                    initialValue: controller.offerPrice.value == 0
                        ? ""
                        : controller.offerPrice.toString(),
                    labelText: "Offer Price",
                    onChanged: (val) {
                      controller.offerPrice(int.parse(val));
                    },
                  )),
            ],
          ),
        )
      ],
    );

    // return Container(
    //   alignment: Alignment.bottomRight,
    //   padding: EdgeInsets.symmetric(vertical: 24),
    //   child: Container(
    //     width: Get.width * 0.2,
    //     child: Obx(() => IntegerTextField(
    //           key: Key('dishId_${controller.dishId}'),
    //           initialValue: controller.price.value == 0
    //               ? ""
    //               : controller.price.toString(),
    //           labelText: "Price",
    //           suffixText: "%",
    //           onChanged: (val) {
    //             controller.price(int.parse(val));
    //           },
    //         )),
    //   ),
    // );
  }
}
