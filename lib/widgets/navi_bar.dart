import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NaviBar extends StatelessWidget {
  const NaviBar({Key? key}) : super(key: key);

  Widget _item(icon, text, onTap) {
    return InkWell(
      child: ListTile(
        leading: Icon(Icons.ac_unit),
        title: Text(
          text,
          style: Get.textTheme.bodyText1,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage.getAuthUser();
    return Container(
      color: Colors.white,
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white,border: Border(bottom:  BorderSide(color: Get.theme.dividerColor))),
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
          _item(Icon(Icons.ac_unit), "Shop",
              () => Get.offNamed(Routes.MANAGE_SHOP)),
          _item(Icon(Icons.ac_unit), "Staff",
              () => Get.offNamed(Routes.MANAGE_STAFF)),
          _item(Icon(Icons.ac_unit), "Supplier",
              () => Get.offNamed(Routes.MANAGE_SUPPLIER)),
          _item(Icon(Icons.ac_unit), "Material",
              () => Get.offNamed(Routes.MANAGE_MATERIAL)),
          _item(Icon(Icons.ac_unit), "Catalog",
              () => Get.offNamed(Routes.MANAGE_CATALOG)),
          _item(Icon(Icons.ac_unit), "Menu",
              () => Get.offNamed(Routes.MANAGE_MENU)),
          _item(Icon(Icons.ac_unit), "Printer",
              () => Get.offNamed(Routes.MANAGE_PRINTER)),
          _item(Icon(Icons.ac_unit), "Special Offer",
              () => Get.offNamed(Routes.MANAGE_SPECIALOFFER)),
              
        ],
      ),
    );
  }
}
