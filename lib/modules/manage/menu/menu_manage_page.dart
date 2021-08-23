import 'package:bubble_tea/widgets/body_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dish_detail_page.dart';
import 'menu_manage_controller.dart';

class MenuManagePage extends GetView<MenuManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Left(),
            Expanded(
              child: Column(
                children: [
                  Top(
                    "Menu Manage",
                    add: () {
                      controller.add();
                      Get.dialog(DishDetail());
                    },
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                                color: Colors.white,
                                width: context.width,
                                height: context.height * 0.35,
                                child: Center()),
                            SizedBox(height: 24),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                width: context.width,
                                child: Center(),
                              ),
                            )
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

class MenuGrid extends StatelessWidget {
  MenuGrid({Key? key, required this.list, this.crossAxisCount = 2})
      : super(key: key);

  final list;
  final crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.5,
      padding: EdgeInsets.all(20),
      children: [for (var item in list) MenuItem(item: item)],
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({Key? key, required this.item}) : super(key: key);

  final controller = Get.find<MenuManageController>();

  final item;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          item.picture,
          fit: BoxFit.cover,
        ),
      ),
      footer: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
        clipBehavior: Clip.antiAlias,
        child: GridTileBar(
          backgroundColor: Colors.black45,
          title: MenuItemTitle(
              text:
                  "${item.materialName}     € ${(item.price / 100).toStringAsFixed(2)}",
              fontSize: 28),
          subtitle: 1 == 1 ? MenuItemTitle(text: item.desc) : null,
          trailing: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              size: 32,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class MenuItemTitle extends StatelessWidget {
  const MenuItemTitle({Key? key, required this.text, this.fontSize = 20})
      : super(key: key);
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
