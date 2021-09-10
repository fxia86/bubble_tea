import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/r.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/widgets/modify_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reception_controller.dart';
import 'widgets/dish_options.dart';
import 'widgets/order_list.dart';

class ReceptionPage extends GetView<ReceptionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('ReceptionPage')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Get.theme.primaryColor,
              height: 72,
              child: Row(
                children: [
                  Logo(),
                  Expanded(
                    child: Container(
                      height: 72,
                      child: Obx(() => TabBar(
                            controller: controller.tabController,
                            isScrollable: true,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.white,
                            labelStyle: Get.textTheme.headline5?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 25),
                            unselectedLabelStyle:
                                Get.textTheme.bodyText1?.copyWith(fontSize: 22),
                            indicator: BoxDecoration(color: Colors.white),
                            tabs: [
                              for (var item in controller.catalogs)
                                Tab(
                                  child: Container(
                                    child: Center(child: Text(item.name!)),
                                    width: 100,
                                  ),
                                )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  OrderList(),
                  Expanded(
                    child: Obx(() => TabBarView(
                          controller: controller.tabController,
                          children: [
                            for (var i = 0; i < controller.catalogs.length; i++)
                              MenuGrid(
                                list: i == 0
                                    ? controller.popularList
                                    : controller.dishes.where((element) =>
                                        element.catalogId ==
                                        controller.catalogs[i].id),
                              ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  Logo({Key? key}) : super(key: key);
  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              R.LOGO_WHITE,
              width: 48,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                controller.shopName ?? "",
                style: Get.textTheme.headline5?.copyWith(color: Colors.white),
              ),
            ),
          ),
          PopupMenuButton(
            offset: Offset(-70, 50),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            iconSize: 30,
            onSelected: (v) {
              switch (v) {
                case 1:
                  //sync
                  controller.refresh();
                  break;
                case 2:
                  //modify
                  Get.dialog(ModifyPassword());
                  break;
                case 3:
                  //log out
                  LocalStorage.clearAuthInfo();
                  Get.offNamed(Routes.LOGIN);
                  break;
                default:
              }
            },
            itemBuilder: (c) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Center(
                  child: Icon(
                    Icons.sync,
                    size: Get.theme.iconTheme.size,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: Get.theme.iconTheme.size,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Center(
                  child: Icon(
                    Icons.logout,
                    size: Get.theme.iconTheme.size,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: list.length,
      itemBuilder: (c, i) => MenuItem(item: list.elementAt(i)),
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({Key? key, required this.item, this.deletable = false})
      : super(key: key);
  final controller = Get.find<ReceptionController>();

  final item;
  final bool deletable;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Get.theme.accentColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (item.options.length > 0) {
            controller.setCurrent(item);
            Get.dialog(DishOptions());
          } else {
            controller.order(item);
          }
        },
        splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.25,
              child: Ink.image(
                image: NetworkImage(item.img),
                fit: BoxFit.cover,
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
                      style: Get.textTheme.headline5
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  )),
                  Text("€ ${(item.price / 100).toStringAsFixed(2)}",
                      style: Get.textTheme.headline5),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  item.desc ?? "",
                  style: Get.textTheme.subtitle1,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
