import 'package:bubble_tea/modules/login/login_binding.dart';
import 'package:bubble_tea/modules/login/login_page.dart';
import 'package:bubble_tea/modules/manage/catelog/catalog_manage_binding.dart';
import 'package:bubble_tea/modules/manage/catelog/catalog_manage_page.dart';
import 'package:bubble_tea/modules/manage/material/material_manage_binding.dart';
import 'package:bubble_tea/modules/manage/material/material_manage_page.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_binding.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_page.dart';
import 'package:bubble_tea/modules/manage/printer/printer_manage_binding.dart';
import 'package:bubble_tea/modules/manage/printer/printer_manage_page.dart';
import 'package:bubble_tea/modules/manage/shop/shop_manage_binding.dart';
import 'package:bubble_tea/modules/manage/shop/shop_manage_page.dart';
import 'package:bubble_tea/modules/manage/special/special_manage_binding.dart';
import 'package:bubble_tea/modules/manage/special/special_manage_page.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_binding.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_page.dart';
import 'package:bubble_tea/modules/manage/supplier/supplier_manage_binding.dart';
import 'package:bubble_tea/modules/manage/supplier/supplier_manage_page.dart';
import 'package:bubble_tea/modules/shop/shop_binding.dart';
import 'package:bubble_tea/modules/shop/shop_page.dart';
import 'package:get/get.dart';

part 'routes.dart';

class Pages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.SHOP,
      page: () => ShopPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SHOP,
      page: () => ShopManagePage(),
      binding: ShopManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_STAFF,
      page: () => StaffManagePage(),
      binding: StaffManageBinding(),
    ),
    
    GetPage(
      name: Routes.MANAGE_SUPPLIER,
      page: () => SupplierManagePage(),
      binding: SupplierManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_CATALOG,
      page: () => CatalogManagePage(),
      binding: CatalogManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_MENU,
      page: () => MenuManagePage(),
      binding: MenuManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_MATERIAL,
      page: () => MaterialManagePage(),
      binding: MaterialManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_PRINTER,
      page: () => PrinterManagePage(),
      binding: PrinterManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SPECIALOFFER,
      page: () => SpecialManagePage(),
      binding: SpecialManageBinding(),
    )
  ];
}
