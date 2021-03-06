// import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:reorderables/reorderables.dart';

import 'menu_manage_controller.dart';

class MenuManagePage extends GetView<MenuManageController> {
  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      top: Top(
        "Menu Manage",
        add: () => Get.toNamed(Routes.MANAGE_MENU_DISH),
      ),
      body: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  final controller = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.width,
          height: 60,
          color: Get.theme.accentColor,
          child: Obx(() => TabBar(
                controller: controller.tabController,
                isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black87,
                labelStyle: Get.textTheme.bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 22),
                unselectedLabelStyle: Get.textTheme.bodyText1,
                indicatorWeight: 3,
                tabs: [
                  for (var item in controller.catalogs) Tab(text: item.name)
                ],
              )),
        ),
        Flexible(
          child: Obx(() => TabBarView(
                controller: controller.tabController,
                children: [
                  for (var i = 0; i < controller.catalogs.length; i++)
                    i == 0
                        ? MenuGrid(
                            list: controller.items
                                .where((element) => element.isPopular!))
                        : ReorderMenu(
                            list: controller.items.where((element) =>
                                element.catalogId == controller.catalogs[i].id),
                          ),
                ],
              )),
        ),
      ],
    );
  }
}

class ReorderMenu extends StatelessWidget {
  ReorderMenu({Key? key, required this.list}) : super(key: key);
  final list;
  final controller = Get.find<MenuManageController>();

  @override
  Widget build(BuildContext context) {
    // bool collapsed = LocalStorage.getNaviBarcollapsed();
    // return SingleChildScrollView(
    //   child: ReorderableWrap(
    //     spacing: 12,
    //     runSpacing: 12,
    //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
    //     children: [
    //       for (var item in list)
    //         Container(
    //             width: Get.width * (collapsed ? 0.295 : 0.228),
    //             height: Get.width * (collapsed ? 0.295 : 0.245),
    //             child: MenuItem(item: item, deletable: true))
    //     ],
    //     onReorder: (int oldIndex, int newIndex) =>
    //         controller.reorder(oldIndex, newIndex, list.toList()[0].catalogId),
    //     // onNoReorder: (int index) {
    //     //   //this callback is optional
    //     //   debugPrint(
    //     //       '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
    //     // },
    //     // onReorderStarted: (int index) {
    //     //   //this callback is optional
    //     //   debugPrint(
    //     //       '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
    //     // },
    //   ),
    // );
    return DragAndDropGridView(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      onWillAccept: (int oldIndex, int newIndex) => oldIndex != newIndex,
      onReorder: (int oldIndex, int newIndex) =>
          controller.reorder(oldIndex, newIndex, list.toList()[0].catalogId),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // childAspectRatio: 0.9,
      ),
      itemCount: list.length,
      itemBuilder: (c, i) => MenuItem(item: list.elementAt(i),deletable: true,),
    );
  }
}

class MenuGrid extends StatelessWidget {
  MenuGrid({Key? key, required this.list, this.crossAxisCount = 3})
      : super(key: key);

  final list;
  final crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // childAspectRatio: 0.9,
      ),
      itemCount: list.length,
      itemBuilder: (c, i) => MenuItem(item: list.elementAt(i)),
    );
  }
}

// ignore: must_be_immutable
class MenuItem extends StatelessWidget {
  MenuItem({Key? key, required this.item, this.deletable = false})
      : super(key: key);
  final controller = Get.find<MenuManageController>();

  final item;
  final bool deletable;

  int variableSet = 0;
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Get.theme.accentColor,
      // This ensures that the Card's children (including the ink splash) are clipped correctly.
      clipBehavior: Clip.antiAlias,
      // shape: ShapeBorder(),
      child: InkWell(
          onTap: () => Get.toNamed(Routes.MANAGE_MENU_DISH, arguments: item.id),
          // onLongPress: () => controller.deleteConfirm(item.id),
          // Generally, material cards use onSurface with 12% opacity for the pressed state.
          splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
          // Generally, material cards do not have a highlight overlay.
          highlightColor: Colors.transparent,
          child: LayoutBuilder(builder: (context, costrains) {
            if (variableSet == 0) {
              width = costrains.maxWidth;
              height = costrains.maxHeight;
              variableSet++;
            }
            return Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.25,
                      child: Ink.image(
                        image: NetworkImage(item.img),
                        fit: BoxFit.cover,
                        child: Container(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              item.name,
                              style: Get.textTheme.headline5,
                            ),
                          )),
                          Text("??? ${(item.price / 100).toStringAsFixed(2)}",
                              style: Get.textTheme.headline5
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.desc ?? "",
                                style: Get.textTheme.subtitle1,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            if (deletable)
                              ScaleIconButton(
                                onPressed: () =>
                                    controller.deleteConfirm(item.id),
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          })),
    );
  }
}
