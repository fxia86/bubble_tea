import 'package:bubble_tea/data/http/http_client.dart';
import 'package:get/get.dart';

final http = Get.find<HttpClient>();

class ServiceUrl {
  static const LOGIN = "/api/auth/login";
  static const REFRESH = "/api/auth/refresh";

  static const SHOP = "/api/shop";
  static const STAFF = "/api/staff";
  static const SUPPLIER = "/api/supplier";
  static const Material = "/api/material";
  static const CATALOG = "/api/catalog";
  static const DISH = "/api/dish";
  static const PRINTER = "/api/printer";
}
