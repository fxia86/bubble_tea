import 'package:bubble_tea/data/models/catalog_model.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

import 'addition_manage_controller.dart';

class AdditionManagePage extends GetView<AdditionManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Addition Manage",
        search: (val) => controller.keywords(val),
        add: controller.add,
      ),
      body: AdditionList(),
      other: Obx(() => controller.showForm.value ? AdditionForm() : SizedBox()),
    );
  }
}

class AdditionList extends StatelessWidget {
  final controller = Get.find<AdditionManageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items
          .where((e) => e.name!.contains(controller.keywords))
          .toList();

      // return SingleChildScrollView(
      //   child: Wrap(
      //     spacing: 10,
      //     runSpacing: 10,
      //     children: [
      //       for (var item in items)
      //         Container(
      //           width: Get.width * 0.22,
      //           child: Card(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.symmetric(horizontal: 20),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text(
      //                         item.name ?? "",
      //                         style: Get.textTheme.bodyText1
      //                             ?.copyWith(fontWeight: FontWeight.w500),
      //                       ),
      //                       PopupMenuButton(
      //                         // offset: Offset(-30,30),
      //                         iconSize: Get.theme.iconTheme.size,
      //                         onSelected: (v) {
      //                           switch (v) {
      //                             case 1:
      //                               //add option
      //                               controller.addOption(item.id);
      //                               Get.dialog(OptionForm());
      //                               break;
      //                             case 2:
      //                               //edit
      //                               controller.edit(item.id);
      //                               break;
      //                             case 3:
      //                               controller.deleteConfirm(item.id);
      //                               break;
      //                             default:
      //                           }
      //                         },
      //                         itemBuilder: (c) => <PopupMenuEntry<int>>[
      //                           PopupMenuItem(
      //                               value: 1, child: Text("Add Option")),
      //                           PopupMenuItem(value: 2, child: Text("Edit")),
      //                           PopupMenuItem(value: 3, child: Text("Delete")),
      //                         ],
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 Divider(),
      //                 for (var option in item.options)
      //                   Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: 20),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Text(
      //                           option.name ?? "",
      //                           style: Get.textTheme.bodyText1,
      //                         ),
      //                         ButtonBar(
      //                           buttonPadding:
      //                               EdgeInsets.symmetric(horizontal: 0),
      //                           children: [
      //                             ScaleIconButton(
      //                                 onPressed: () {
      //                                   controller.editOption(option.id);
      //                                   Get.dialog(OptionForm());
      //                                 },
      //                                 icon: Icon(Icons.edit)),
      //                             ScaleIconButton(
      //                                 onPressed: () => controller
      //                                     .deleteOptionConfirm(option.id),
      //                                 icon: Icon(Icons.close))
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   )
      //               ],
      //             ),
      //           ),
      //         )
      //     ],
      //   ),
      // );

      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (c, i) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            items[i].name ?? "",
                            style: Get.textTheme.bodyText1
                                ?.copyWith(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        PopupMenuButton(
                          // offset: Offset(-30,30),
                          iconSize: Get.theme.iconTheme.size,
                          onSelected: (v) {
                            switch (v) {
                              case 1:
                                //add option
                                controller.addOption(items[i].id);
                                Get.dialog(OptionForm());
                                break;
                              case 2:
                                //edit
                                controller.edit(items[i].id);
                                break;
                              case 3:
                                controller.deleteConfirm(items[i].id);
                                break;
                              default:
                            }
                          },
                          itemBuilder: (c) => <PopupMenuEntry<int>>[
                            PopupMenuItem(value: 1, child: Text("Add Option")),
                            PopupMenuItem(value: 2, child: Text("Edit")),
                            PopupMenuItem(value: 3, child: Text("Delete")),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: items[i].options.length,
                        itemBuilder: (c, j) {
                          final option = items[i].options[j];
                          return Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    option.name ?? "",
                                    style: Get.textTheme.bodyText1,
                                  ),
                                ),
                                ScaleIconButton(
                                  onPressed: () {
                                    controller.editOption(option.id);
                                    Get.dialog(OptionForm());
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                ScaleIconButton(
                                  onPressed: () =>
                                      controller.deleteOptionConfirm(option.id),
                                  icon: Icon(Icons.close),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}

class AdditionForm extends StatelessWidget {
  final controller = Get.find<AdditionManageController>();

  @override
  Widget build(BuildContext context) {
    return DialogForm(
      onWillPop: () => controller.showForm(false),
      form: Container(
        color: Colors.white,
        width: context.width * 0.3,
        height: context.height,
        padding: EdgeInsets.all(20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CatalogSelect(),
                SizedBox(height: 30),
                SimpleTextField(
                  initialValue: controller.editItem.value.name,
                  labelText: "Name",
                  onChanged: (val) {
                    controller.editItem.value.name = val.trim();
                  },
                ),
                SizedBox(height: 30),
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
            ),
          ),
        ),
      ),
    );
  }
}

class OptionForm extends StatelessWidget {
  final controller = Get.find<AdditionManageController>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          width: context.width * 0.3,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              SimpleTextField(
                initialValue: controller.editOptionItem.value.name,
                labelText: "Option Name",
                onChanged: (val) {
                  controller.editOptionItem.value.name = val.trim();
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (controller.editOptionItem.value.name == null ||
                      controller.editOptionItem.value.name!.isEmpty) {
                    return;
                  }
                  await controller.saveOption();
                },
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
              )
            ],
          ),
        )
      ],
    );
  }
}

class CatalogSelect extends StatelessWidget {
  final controller = Get.find<AdditionManageController>();

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
                    controller.editItem.value.catalogId == null
                        ? "Catalog"
                        : controller.catalogs
                            .firstWhere((element) =>
                                element.id == controller.editItem.value.catalogId)
                            .name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.editItem.value.catalogId == null
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
      items: controller.catalogs,
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