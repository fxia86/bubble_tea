import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/r.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/widgets/modify_password.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:bubble_tea/widgets/qrcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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
                      child: Obx(() => controller.searching.value
                          ? SearchBar()
                          : TabBar(
                              controller: controller.tabController,
                              isScrollable: true,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.white,
                              labelStyle: Get.textTheme.headline5?.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 25),
                              unselectedLabelStyle: Get.textTheme.bodyText1
                                  ?.copyWith(fontSize: 22),
                              indicator: BoxDecoration(color: Colors.white),
                              tabs: [
                                for (var item in controller.catalogs)
                                  Tab(
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(minWidth: 100),
                                      child: Center(child: Text(item.name!)),
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
                    child: Obx(() => controller.searching.value
                        ? SearchResult()
                        : TabBarView(
                            controller: controller.tabController,
                            children: [
                              for (var i = 0;
                                  i < controller.catalogs.length;
                                  i++)
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
                case 0:
                  controller.searching(!controller.searching.value);
                  controller.keywords("");
                  break;
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
                value: 0,
                child: Center(
                  child: Icon(
                    controller.searching.value
                        ? Icons.search_off
                        : Icons.search,
                    size: Get.theme.iconTheme.size,
                  ),
                ),
              ),
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
  MenuItem({Key? key, required this.item}) : super(key: key);

  final controller = Get.find<ReceptionController>();
  final item;

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

class SearchBar extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Get.width * 0.375,
          height: Get.height * 0.481,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.only(left: 20, top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ValueBuilder<bool?>(
            initialValue: _textEditingController.text == "",
            builder: (value, updateFn) => TextFormField(
              controller: _textEditingController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  size: Get.theme.iconTheme.size! * 1.5,
                ),
                // contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                border: InputBorder.none,
                hintText: "Search",
                suffixIcon: value!
                    ? null
                    : ScaleIconButton(
                        onPressed: () {
                          if (!_focusNode.hasFocus) {
                            _focusNode.canRequestFocus = false;
                            Future.delayed(Duration(milliseconds: 300), () {
                              _focusNode.canRequestFocus = true;
                            });
                          }
                          updateFn(true);

                          controller.keywords("");
                          _textEditingController.clear();
                        },
                        icon: Icon(
                          Icons.close,
                        )),
              ),
              style: Get.textTheme.bodyText1,
              onChanged: (val) {
                updateFn(val == "");
                controller.keywords(val);
              },
            ),
          ),
        ),
        Container(
          height: Get.height * 0.052,
          child: ElevatedButton(
            onPressed: () async {
              if (await Permission.camera.request().isGranted)
                Get.dialog(QrcodeScanner(
                  onCapture: (data) {
                    Get.back();
                    controller.keywords(data);
                  },
                ));
            },
            child: Icon(
              Icons.qr_code_scanner,
              size: Get.theme.iconTheme.size! * 1.25,
              color: Colors.black87,
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
          ),
        )
      ],
    );
  }
}

class SearchResult extends StatelessWidget {
  SearchResult({Key? key}) : super(key: key);

  final controller = Get.find<ReceptionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var keywords = controller.keywords.toLowerCase();
      return MenuGrid(
        list: keywords == ""
            ? []
            : controller.dishes.where((element) =>
                element.name!.toLowerCase().contains(keywords) ||
                element.code!.toLowerCase().contains(keywords)),
      );
    });
  }
}
