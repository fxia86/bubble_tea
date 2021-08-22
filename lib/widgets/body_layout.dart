import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Left extends StatelessWidget {
  const Left({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage.getAuthUser();

    return Container(
      color: Colors.white,
      width: Get.width * 0.2,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Get.theme.dividerColor))),
            accountName: Text(
              user.name!,
              style: Get.textTheme.bodyText1,
            ),
            accountEmail: Text(
              user.email!,
              style: Get.textTheme.subtitle1,
            ),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(
                size: 42,
              ),
            ),
            // onDetailsPressed: (){ print("object");},
          ),
          Expanded(
            child: ListView(
              // padding: EdgeInsets.zero,
              children: [
                NaviItem(
                    text: "Shop",
                    routeName: Routes.MANAGE_SHOP,
                    iconData: Icons.storefront),
                NaviItem(
                    text: "Staff",
                    routeName: Routes.MANAGE_STAFF,
                    iconData: Icons.people),
                NaviItem(
                    text: "Supplier",
                    routeName: Routes.MANAGE_SUPPLIER,
                    iconData: Icons.person_search),
                NaviItem(
                    text: "Material",
                    routeName: Routes.MANAGE_MATERIAL,
                    iconData: Icons.category),
                NaviItem(
                    text: "Catalog",
                    routeName: Routes.MANAGE_CATALOG,
                    iconData: Icons.dashboard),
                NaviItem(
                    text: "Menu",
                    routeName: Routes.MANAGE_MENU,
                    iconData: Icons.restaurant_menu),
                NaviItem(
                    text: "Printer",
                    routeName: Routes.MANAGE_PRINTER,
                    iconData: Icons.print),
                NaviItem(
                    text: "Special Offer",
                    routeName: Routes.MANAGE_SPECIALOFFER,
                    iconData: Icons.local_offer),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
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
      required this.iconData})
      : super(key: key);

  final String text;
  final String routeName;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Get.currentRoute == routeName
          ? Container(
              color: Get.theme.accentColor,
              child: ListTile(
                leading: Icon(iconData, color: Get.theme.primaryColor),
                title: Text(
                  text,
                  style: Get.textTheme.bodyText1
                      ?.copyWith(color: Get.theme.primaryColor),
                ),
              ),
            )
          : Container(
              child: ListTile(
                leading: Icon(iconData),
                title: Text(
                  text,
                  style: Get.textTheme.bodyText1,
                ),
              ),
            ),
      onTap: () => Get.offNamed(routeName),
    );
  }
}

class Top extends StatelessWidget {
  Top(this.title, {Key? key, this.add, this.search}) : super(key: key);

  final String title;
  final VoidCallback? add;
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
          Text(
            title,
            style:
                Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
          ),
          search == null
              ? SizedBox()
              : Container(
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
                          size: 32,
                        ),
                        // contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        border: InputBorder.none,
                        hintText: "Search",
                        suffixIcon: value!
                            ? null
                            : IconButton(
                                onPressed: () {
                                  if (!_focusNode.hasFocus) {
                                    _focusNode.canRequestFocus = false;
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
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
