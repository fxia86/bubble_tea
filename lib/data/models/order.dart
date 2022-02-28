import 'package:bubble_tea/data/models/base.dart';

class OrderModel extends BaseModel {
  String? shopId;
  int? payment;
  String? sn;
  String? date;
  int? originalPrice;
  int? offerPrice;
  int? discount;
  List<OrderDishModel> dishes = <OrderDishModel>[];
  String? desc;

  OrderModel({
    String? id,
    this.shopId,
    this.payment,
    this.sn,
    this.date,
    this.originalPrice,
    this.offerPrice,
    this.discount,
    this.desc,
  }) : super(id: id);

  OrderModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.shopId = json['shopId'];
    this.payment = json['payment'];
    this.sn = json['sn'];
    this.date = json['date'];
    this.originalPrice = json['originalPrice'];
    this.offerPrice = json['offerPrice'];
    this.discount = json['discount'];
    if (json['dishes'] != null) {
      this.dishes = List.castFrom(json['dishes'])
          .map((v) => OrderDishModel.fromJson(v))
          .toList();
    }
    this.desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['payment'] = this.payment;
    data['sn'] = this.sn;
    data['date'] = this.date;
    data['originalPrice'] = this.originalPrice;
    data['offerPrice'] = this.offerPrice;
    data['discount'] = this.discount;
    data['dishes'] = List.castFrom(this.dishes.map((e) => e.toJson()).toList());
    return data;
  }
}

class OrderDishModel extends BaseModel {
  String? orderId;
  String? dishId;
  String? optionIds;
  String? desc;
  int? originalPrice;
  int? offerPrice;
  String? specialOffer; // special offer type, eg: in a bundle
  int? qty;

  OrderDishModel({
    String? id,
    this.orderId,
    this.dishId,
    this.optionIds,
    this.desc,
    this.originalPrice,
    this.offerPrice,
    this.specialOffer,
    this.qty,
  }) : super(id: id);

  OrderDishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.orderId = json['orderId'];
    this.dishId = json['dishId'];
    this.optionIds = json['optionIds'];
    this.desc = json['desc'];
    this.originalPrice = json['originalPrice'];
    this.offerPrice = json['offerPrice'];
    this.specialOffer = json['specialOffer'];
    this.qty = json['qty'];
  }

  OrderDishModel.copyWith(OrderDishModel other) {
    this.id = other.id;
    this.orderId = other.orderId;
    this.dishId = other.dishId;
    this.optionIds = other.optionIds;
    this.desc = other.desc;
    this.originalPrice = other.originalPrice;
    this.offerPrice = other.offerPrice;
    this.specialOffer = other.specialOffer;
    this.qty = other.qty;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['dishId'] = this.dishId;
    data['optionIds'] = this.optionIds;
    data['desc'] = this.desc;
    data['originalPrice'] = this.originalPrice;
    data['offerPrice'] = this.offerPrice;
    data['specialOffer'] = this.specialOffer;
    data['qty'] = this.qty;
    return data;
  }
}

class OrderStatisticModel {
  String? date;
  String? shop;
  String? catalogName;
  int? totalAmount;
  int? cardAmount;

  OrderStatisticModel({
    this.date,
    this.shop,
    this.catalogName,
    this.totalAmount,
    this.cardAmount,
  });

  OrderStatisticModel.fromJson(Map<String, dynamic> json) {
    this.date = json['date'];
    this.shop = json['shop'];
    this.catalogName = json['catalogName'];
    this.totalAmount = json['totalAmount'];
    this.cardAmount = json['cardAmount'];
  }
}

class OrderNumStatisticModel {
  int? hour;
  String? shopId;
  int? num;

  OrderNumStatisticModel({
    this.hour,
    this.shopId,
    this.num,
  });

  OrderNumStatisticModel.fromJson(Map<String, dynamic> json) {
    this.hour = json['hour'];
    this.shopId = json['shopId'];
    this.num = json['num'];
  }
}
