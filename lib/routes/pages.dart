import 'package:bubble_tea/modules/admin/merchant/manager/merchant_manager_binding.dart';
import 'package:bubble_tea/modules/admin/merchant/manager/merchant_manager_page.dart';
import 'package:bubble_tea/modules/admin/merchant/merchant_binding.dart';
import 'package:bubble_tea/modules/admin/merchant/merchant_page.dart';
import 'package:bubble_tea/modules/login/login_binding.dart';
import 'package:bubble_tea/modules/login/login_page.dart';
import 'package:bubble_tea/modules/manage/addition/addition_manage_binding.dart';
import 'package:bubble_tea/modules/manage/addition/addition_manage_page.dart';
import 'package:bubble_tea/modules/manage/catelog/catalog_manage_binding.dart';
import 'package:bubble_tea/modules/manage/catelog/catalog_manage_page.dart';
import 'package:bubble_tea/modules/manage/material/material_manage_binding.dart';
import 'package:bubble_tea/modules/manage/material/material_manage_page.dart';
import 'package:bubble_tea/modules/manage/menu/dish/dish_detail_binding.dart';
import 'package:bubble_tea/modules/manage/menu/dish/dish_detail_page.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_binding.dart';
import 'package:bubble_tea/modules/manage/menu/menu_manage_page.dart';
import 'package:bubble_tea/modules/manage/printer/printer_manage_binding.dart';
import 'package:bubble_tea/modules/manage/printer/printer_manage_page.dart';
import 'package:bubble_tea/modules/manage/shop/shop_manage_binding.dart';
import 'package:bubble_tea/modules/manage/shop/shop_manage_page.dart';
import 'package:bubble_tea/modules/manage/special/bundle/bundle_page.dart';
import 'package:bubble_tea/modules/manage/special/discount/discount_page.dart';
import 'package:bubble_tea/modules/manage/special/price/price_page.dart';
import 'package:bubble_tea/modules/manage/special/special_manage_binding.dart';
import 'package:bubble_tea/modules/manage/special/special_manage_page.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_binding.dart';
import 'package:bubble_tea/modules/manage/staff/staff_manage_page.dart';
import 'package:bubble_tea/modules/manage/supplier/supplier_manage_binding.dart';
import 'package:bubble_tea/modules/manage/supplier/supplier_manage_page.dart';
import 'package:bubble_tea/modules/reception/reception_binding.dart';
import 'package:bubble_tea/modules/reception/reception_page.dart';
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
      name: Routes.RECEPTION,
      page: () => ReceptionPage(),
      binding: ReceptionBinding(),
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
      name: Routes.MANAGE_ADDITION,
      page: () => AdditionManagePage(),
      binding: AdditionManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_MENU,
      page: () => MenuManagePage(),
      binding: MenuManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_MENU_DISH,
      page: () => DishDetailPage(),
      binding: DishDetailBinding(),
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
      name: Routes.MANAGE_SPECIAL,
      page: () => SpecialManagePage(),
      binding: SpecialManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SPECIAL_DISCOUNT,
      page: () => DiscountPage(),
      binding: SpecialManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SPECIAL_BUNDLE,
      page: () => BundlePage(),
      binding: SpecialManageBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SPECIAL_PRICE,
      page: () => PricePage(),
      binding: SpecialManageBinding(),
    ),
    GetPage(
      name: Routes.MERCHANT,
      page: () => MerchantPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: Routes.MERCHANT_MANAGER,
      page: () => MerchantManagerPage(),
      binding: MerchantManagerBinding(),
    ),
  ];
}
