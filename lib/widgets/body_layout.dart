import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/r.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modify_password.dart';
import 'my_icon_button.dart';

class BodyLayout extends StatelessWidget {
  BodyLayout({Key? key, required this.top, required this.body, this.other})
      : super(key: key);

  final Top top;
  final Widget body;
  final Widget? other;

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
                      top,
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: body,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: other,
            )
          ],
        ),
      ),
    );
  }
}

class Left extends StatefulWidget {
  const Left({Key? key}) : super(key: key);

  @override
  _LeftState createState() => _LeftState();
}

class _LeftState extends State<Left> {
  bool collapsed = LocalStorage.getNaviBarcollapsed();
  final user = LocalStorage.getAuthUser();

  List<NaviItem> _getNaviItems() {
    if (user.role == 1) {
      return [
        NaviItem(
          text: "Merchant",
          routeName: Routes.MERCHANT,
          iconData: Icons.groups,
          collapsed: collapsed,
        ),
      ];
    }

    return [
      NaviItem(
        text: "Shop",
        routeName: Routes.MANAGE_SHOP,
        iconData: Icons.storefront,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Staff",
        routeName: Routes.MANAGE_STAFF,
        iconData: Icons.people,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Supplier",
        routeName: Routes.MANAGE_SUPPLIER,
        iconData: Icons.person_search,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Material",
        routeName: Routes.MANAGE_MATERIAL,
        iconData: Icons.category,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Catalog",
        routeName: Routes.MANAGE_CATALOG,
        iconData: Icons.dashboard,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Addition",
        routeName: Routes.MANAGE_ADDITION,
        iconData: Icons.fact_check,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Menu",
        routeName: Routes.MANAGE_MENU,
        iconData: Icons.restaurant_menu,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Printer",
        routeName: Routes.MANAGE_PRINTER,
        iconData: Icons.print,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Special Offer",
        routeName: Routes.MANAGE_SPECIAL,
        iconData: Icons.local_offer,
        collapsed: collapsed,
      ),
      NaviItem(
        text: "Report",
        routeName: Routes.MANAGE_REPORT,
        iconData: Icons.table_chart,
        collapsed: collapsed,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return collapsed
        ? Container(
            color: Colors.white,
            width: Get.width * 0.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Icon(Icons.menu),
                  onTap: () {
                    LocalStorage.setNaviBarcollapsed(!collapsed);
                    setState(() {
                      collapsed = !collapsed;
                    });
                  },
                ),
                ListTile(
                  title: Icon(Icons.person),
                  onTap: () => Get.dialog(ModifyPassword()),
                ),
                Divider(),
                Expanded(
                  child: ListView(
                    // padding: EdgeInsets.zero,
                    children: _getNaviItems(),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Icon(Icons.logout),
                  onTap: () {
                    LocalStorage.clearAuthInfo();
                    Get.offNamed(Routes.LOGIN);
                  },
                )
              ],
            ))
        : Container(
            color: Colors.white,
            width: Get.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UserAccountsDrawerHeader(
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       border:
                //           Border(bottom: BorderSide(color: Get.theme.dividerColor))),
                //   accountName: Text(
                //     user.name!,
                //     style: Get.textTheme.bodyText1,
                //   ),
                //   accountEmail: Text(
                //     user.email!,
                //     style: Get.textTheme.subtitle1,
                //   ),
                //   currentAccountPicture: CircleAvatar(
                //     child: FlutterLogo(
                //       size: 42,
                //     ),
                //   ),
                //   // onDetailsPressed: (){ print("object");},
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        R.LOGO_BLUE,
                        width: 48,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            user.merchantName ?? "E-POS",
                            style: Get.textTheme.headline5?.copyWith(
                                color: Get.theme.primaryColor.withAlpha(160)),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          LocalStorage.setNaviBarcollapsed(!collapsed);
                          setState(() {
                            collapsed = !collapsed;
                          });
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    user.name!,
                    style: Get.textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    user.email!,
                    style: Get.textTheme.subtitle1,
                  ),
                  trailing: IconButton(
                      onPressed: () => Get.dialog(ModifyPassword()),
                      icon: Icon(Icons.person)),
                ),
                Divider(),
                Expanded(
                  child: ListView(
                    // padding: EdgeInsets.zero,
                    children: _getNaviItems(),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Log out",
                    style: Get.textTheme.bodyText1,
                  ),
                  onTap: () {
                    LocalStorage.clearAuthInfo();
                    Get.offNamed(Routes.LOGIN);
                  },
                )
              ],
            ),
          );
  }
}

class NaviItem extends StatelessWidget {
  const NaviItem(
      {Key? key,
      required this.text,
      required this.routeName,
      required this.iconData,
      this.collapsed = false})
      : super(key: key);

  final String text;
  final String routeName;
  final IconData iconData;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    var selected = Get.currentRoute == routeName;
    var row = collapsed
        ? ListTile(
            title: selected
                ? Icon(iconData, color: Get.theme.primaryColor)
                : Icon(iconData),
          )
        : ListTile(
            leading: selected
                ? Icon(iconData, color: Get.theme.primaryColor)
                : Icon(iconData),
            title: selected
                ? Text(
                    text,
                    style: Get.textTheme.bodyText1
                        ?.copyWith(color: Get.theme.primaryColor),
                  )
                : Text(
                    text,
                    style: Get.textTheme.bodyText1,
                  ),
          );

    return InkWell(
      child: selected
          ? Container(color: Get.theme.accentColor, child: row)
          : Container(child: row),
      onTap: () => Get.offNamed(routeName),
    );
  }
}

class Top extends StatelessWidget {
  Top(this.title, {Key? key, this.child, this.add, this.scan, this.search})
      : super(key: key);

  final String title;
  final Widget? child;
  final VoidCallback? add;
  final VoidCallback? scan;
  final Function(String? val)? search;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.085,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child == null
              ? Text(
                  title,
                  style: Get.textTheme.headline5
                      ?.copyWith(fontWeight: FontWeight.w500),
                )
              : child!,
          if (search != null)
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
                              search!("");
                              _textEditingController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                            )),
                  ),
                  style: Get.textTheme.bodyText1,
                  onChanged: (val) {
                    search!(val);
                    updateFn(val == "");
                  },
                ),
              ),
            ),
          if (scan != null)
            Container(
              height: Get.height * 0.052,
              child: ElevatedButton(
                onPressed: scan,
                child: Icon(
                  Icons.qr_code_scanner,
                  size: Get.theme.iconTheme.size! * 1.25,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigo[300])),
              ),
            ),
          Container(
            height: Get.height * 0.052,
            child: add == null
                ? null
                : ElevatedButton.icon(
                    onPressed: add,
                    icon: Icon(Icons.add),
                    label: Text("Add",
                        style: Get.textTheme.bodyText1?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
          )
        ],
      ),
    );
  }
}
