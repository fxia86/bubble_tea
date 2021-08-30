import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/utils/common_utils.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'special_manage_controller.dart';

class SpecialManagePage extends GetView<SpecialManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Special Offer Manage",
        // search: (val) => controller.keywords(val),
        add: () {
          switch (controller.category.value) {
            case 1:
              Get.toNamed(Routes.MANAGE_SPECIAL_DISCOUNT);
              break;
            case 2:
              Get.toNamed(Routes.MANAGE_SPECIAL_BUNDLE);
              break;
            case 3:
              Get.toNamed(Routes.MANAGE_SPECIAL_PRICE);
              break;
            default:
              return;
          }
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              CategoryButton(category: 1),
              Container(
                color: Get.theme.dividerColor,
                height: 20,
                width: 2,
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
              CategoryButton(category: 2),
              Container(
                color: Get.theme.dividerColor,
                height: 20,
                width: 2,
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
              CategoryButton(category: 3),
            ],
          ),
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: [
                  Container(
                    color: Colors.white,
                    child: Obx(() {
                      switch (controller.category.value) {
                        case 1:
                          return DiscountTable();
                        case 2:
                          return BundleTable();
                        case 3:
                          return PriceTable();
                        default:
                          return SizedBox();
                      }
                    }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  CategoryButton({Key? key, required this.category}) : super(key: key);

  final controller = Get.find<SpecialManageController>();
  final int category;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var text = "";
      switch (category) {
        case 1:
          text = "Buy 1 get 1";
          break;
        case 2:
          text = "Bundle";
          break;
        case 3:
          text = "Price";
          break;
        default:
      }

      final selected = controller.category.value == category;
      return Container(
        child: TextButton(
            onPressed: selected ? null : () => controller.category(category),
            child: Text(
              text,
              style: Get.textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? Get.theme.primaryColor : Colors.black87),
            )),
      );
    });
  }
}

class DiscountTable extends StatelessWidget {
  final controller = Get.find<SpecialManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.discounts)
              DataRow(cells: [
                DataCell(Text(item.dishName ?? "")),
                DataCell(Text("${item.discount}%")),
                DataCell(Row(
                  children: [
                    ScaleIconButton(
                      onPressed: () => Get.toNamed(
                          Routes.MANAGE_SPECIAL_DISCOUNT,
                          arguments: item),
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                    ScaleIconButton(
                      onPressed: () => controller.deleteConfirm(item.id),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                )),
              ])
          ],
        ));
  }
}

class BundleTable extends StatelessWidget {
  final controller = Get.find<SpecialManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Offer Price')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.bundles)
              DataRow(cells: [
                DataCell(Text(item.dishes.map((e) => "${e.dishName} * ${e.qty}").join(", "))),
                DataCell(
                    Text("€  ${(item.offerPrice! / 100).toStringAsFixed(2)}")),
                DataCell(Row(
                  children: [
                    ScaleIconButton(
                      onPressed: () => Get.toNamed(
                          Routes.MANAGE_SPECIAL_BUNDLE,
                          arguments: item),
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                    ScaleIconButton(
                      onPressed: () => controller.deleteConfirm(item.id),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                )),
              ])
          ],
        ));
  }
}

class PriceTable extends StatelessWidget {
  final controller = Get.find<SpecialManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Original Price')),
            DataColumn(label: Text('Offer Price')),
            DataColumn(label: Text('Available Date')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (var item in controller.prices)
              DataRow(cells: [
                DataCell(Text(item.dishName ?? "")),
                DataCell(Text(
                    "€  ${(item.originalPrice! / 100).toStringAsFixed(2)}")),
                DataCell(
                    Text("€  ${(item.offerPrice! / 100).toStringAsFixed(2)}")),
                DataCell(Text(
                    "${CommonUtils.toDateString(item.start!)}\n        to\n${CommonUtils.toDateString(item.end!)}")),
                DataCell(Row(
                  children: [
                    ScaleIconButton(
                      onPressed: () => Get.toNamed(Routes.MANAGE_SPECIAL_PRICE,
                          arguments: item),
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                    ScaleIconButton(
                      onPressed: () => controller.deleteConfirm(item.id),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                )),
              ])
          ],
        ));
  }
}
