import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addition_manage_controller.dart';

class AdditionManagePage extends GetView<AdditionManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Left(),
                Expanded(
                  child: Column(
                    children: [
                      Top(
                        "Addition Manage",
                        search: (val) => controller.keywords(val),
                        add: controller.add,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: AdditionList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => controller.showForm.value ? AdditionForm() : SizedBox())
          ],
        ),
      ),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          items[i].name ?? "",
                          style: Get.textTheme.bodyText1
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        PopupMenuButton(
                          // offset: Offset(-30,30),
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
                  for (var option in items[i].options)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option.name ?? "",
                            style: Get.textTheme.bodyText1,
                          ),
                          ButtonBar(
                            buttonPadding: EdgeInsets.symmetric(horizontal: 0),
                            children: [
                              IconButton(
                                  onPressed: () {
                                    controller.editOption(option.id);
                                    Get.dialog(OptionForm());
                                  },
                                  icon: Icon(Icons.edit,size: 20,)),
                              IconButton(
                                  onPressed: () =>
                                      controller.deleteOptionConfirm(option.id),
                                  icon: Icon(Icons.close,size: 20))
                            ],
                          )
                        ],
                      ),
                    )
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
                SizedBox(height: 30),
                SimpleTextInput(
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
              SimpleTextInput(
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
