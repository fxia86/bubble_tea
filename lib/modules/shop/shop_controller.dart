import 'dart:math';

import 'package:bubble_tea/data/repositories/shop/shop_repository.dart';
import 'package:bubble_tea/r.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopController extends GetxController with SingleGetTickerProviderMixin {
  final ShopRepository repository = Get.find();

  late TabController tabController;

  var catalogs = [
    'Popular',
    'Bubble Tea',
    'Jianbing',
    'Noodles',
    'Rice',
    'Curry',
    'Drink'
  ];

  var popList = <DishModel>[];

  var orderList = <OrderModel>[].obs;
  var crossAxisCount = 3.obs;

  var totalPrice = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: catalogs.length, vsync: this);
    popList = List.generate(
      11,
      (index) => DishModel(
        id: index,
        name: "name$index",
        picture: R.ImageItemList[index],
        desc: "description$index",
        price: Random().nextInt(500),
      ),
    );
  }

  // @override
  // void onReady() {

  // }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // final now = DateTime.now().obs;
  // final _obj = ''.obs;
  // set obj(value) => this._obj.value = value;
  // get obj => this._obj.value;

  void _sum() {
    var sum = 0;
    orderList.forEach((element) {
      sum += element.dish.price * element.count.value;
    });
    totalPrice.value = sum;
  }

  void add(OrderModel item) {
    item.count += 1;
    _sum();
  }

  void remove(OrderModel item) {
    item.count -= 1;
    if (item.count.value == 0) {
      orderList.remove(item);
    }
    if (orderList.length == 0) {
      crossAxisCount.value = 3;
    }
    _sum();
  }

  void order(DishModel item) {
    if (orderList.length == 0) {
      crossAxisCount.value = 2;
    }
    var m = orderList.indexWhere((element) => element.dish.id == item.id);
    if (m >= 0) {
      orderList[m].count += 1;
    } else {
      orderList.add(OrderModel(dish: item, count: 1.obs));
    }
    _sum();
  }

  void place() {
    orderList.clear();

    MessageBox.success("Order has been placed!");
    //TODO
  }
}

class DishModel {
  late int id;
  late String name;
  late String picture;
  late String desc;
  late int price;

  DishModel({
    required this.id,
    required this.name,
    required this.picture,
    required this.desc,
    required this.price,
  });

  DishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.picture = json['picture'];
    this.desc = json['desc'];
    this.price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['desc'] = this.desc;
    data['price'] = this.price;
    return data;
  }
}

class OrderModel {
  DishModel dish;
  RxInt count;

  OrderModel({required this.dish, required this.count});

  // OrderModel.fromJson(Map<String, dynamic> json) {
  //   this.id = json['id'];
  //   this.name = json['name'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = this.name;
  //   return data;
  // }
}
