import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/dialog_form.dart';
import 'package:bubble_tea/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

import 'catalog_manage_controller.dart';

class CatalogManagePage extends GetView<CatalogManageController> {
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
                        "Catalog Manage",
                        search: (val) => controller.keywords(val),
                        add: controller.add,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: CatalogTable(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => controller.showForm.value ? CatalogForm() : SizedBox())
          ],
        ),
      ),
    );
  }
}

class CatalogTable extends StatelessWidget {
  final controller = Get.find<CatalogManageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Get.theme.accentColor,
          width: context.width,
          height: 56,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 50),
          child: Text('Name',
              style: Get.textTheme.bodyText1
                  ?.copyWith(color: Get.theme.primaryColor)),
        ),
        Expanded(
          child: Obx(() => ReorderableListView(
              buildDefaultDragHandles: false,
              children: [
                for (int index = 0; index < controller.items.length; index++)
                  Container(
                    key: Key('$index'),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Get.theme.dividerColor)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.items[index].name ?? "",
                            style: Get.textTheme.bodyText1),
                        ButtonBar(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  controller.edit(controller.items[index].id),
                              icon: Icon(Icons.edit),
                              color: Colors.orange,
                            ),
                            IconButton(
                              onPressed: () => controller
                                  .deleteConfirm(controller.items[index].id),
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: ReorderableDragStartListener(
                                index: index,
                                child: Icon(Icons.drag_handle),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                controller.reorder(oldIndex, newIndex);
              })),
        ),
      ],
    );
  }
}

// class CatalogTable extends StatelessWidget {
//   final controller = Get.find<CatalogManageController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => ReorderableTable(
//           header: Container(
//             padding: EdgeInsets.only(bottom: 10),
//             decoration:
//                 BoxDecoration(border: Border(bottom: BorderSide(width: 0.1))),
//             child: ReorderableTableRow(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Serial',style: Get.textTheme.bodyText1),
//                 Text('Name',style: Get.textTheme.bodyText1),
//                 Text('',style: Get.textTheme.bodyText1),
//               ],
//             ),
//           ),
//           children: [
//             for (var item in controller.items)
//               ReorderableTableRow(
//                 decoration:
//                     BoxDecoration(border: Border(bottom: BorderSide(width: 5))),
//                 //a key must be specified for each row
//                 key: ObjectKey(item),
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text((controller.items.indexOf(item) + 1).toString(),style: Get.textTheme.bodyText1),
//                   Text(item.name??"",style: Get.textTheme.bodyText1,),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => controller.edit(item.id),
//                         icon: Icon(Icons.edit),
//                         color: Colors.orange,
//                       ),
//                       IconButton(
//                         onPressed: () => controller.deleteConfirm(item.id),
//                         icon: Icon(Icons.delete),
//                         color: Colors.red,
//                       ),
//                     ],
//                   )
//                 ],
//               )
//           ],
//           onReorder: (int oldIndex, int newIndex) =>
//               controller.reorder(oldIndex, newIndex),
//         ));
//   }
// }

class CatalogForm extends StatelessWidget {
  final controller = Get.find<CatalogManageController>();

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
