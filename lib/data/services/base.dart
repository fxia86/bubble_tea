import 'package:bubble_tea/data/http/http_client.dart';
import 'package:get/get.dart';

final http = Get.find<HttpClient>();

class ServiceUrl {
  static const AUTH = "/api/auth";

  static const SHOP = "/api/shop";
  static const USER = "/api/user";
  static const SUPPLIER = "/api/supplier";
  static const Material = "/api/material";
  static const CATALOG = "/api/catalog";
  static const ADDITION = "/api/addition";
  static const ADDITION_OPTION = "/api/addition/option";
  static const DISH = "/api/dish";
  static const PRINTER = "/api/printer";
  static const SPECIAL_DISCOUNT = "/api/special/discount";
  static const SPECIAL_BUNDLE = "/api/special/bundle";
  static const SPECIAL_PRICE = "/api/special/price";
  static const ORDER = "/api/order";
  static const MERCHANT = "/api/merchant";
}
