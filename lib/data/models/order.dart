import 'package:bubble_tea/data/models/base.dart';

class OrderModel extends BaseModel {
  String? shopId;
  int? payment;
  String? sn;
  String? date;
  int? originalPrice;
  int? offerPrice;
  List<OrderDishModel> dishes = <OrderDishModel>[];

  OrderModel({
    String? id,
    this.shopId,
    this.payment,
    this.sn,
    this.date,
    this.originalPrice,
    this.offerPrice,
  }) : super(id: id);

  OrderModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.shopId = json['shopId'];
    this.payment = json['payment'];
    this.sn = json['sn'];
    this.date = json['date'];
    this.originalPrice = json['originalPrice'];
    this.offerPrice = json['offerPrice'];
    if (json['dishes'] != null) {
      this.dishes = List.castFrom(json['dishes'])
          .map((v) => OrderDishModel.fromJson(v))
          .toList();
    }
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
    data['dishes'] = List.castFrom(this.dishes.map((e) => e.toJson()).toList());
    return data;
  }
}

class OrderDishModel extends BaseModel {
  String? orderId;
  String? dishId;
  String? desc;
  int? originalPrice;
  int? offerPrice;
  String? specialOffer; // special offer type, eg: in a bundle
  int? qty;

  OrderDishModel({
    String? id,
    this.orderId,
    this.dishId,
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
    data['desc'] = this.desc;
    data['originalPrice'] = this.originalPrice;
    data['offerPrice'] = this.offerPrice;
    data['specialOffer'] = this.specialOffer;
    data['qty'] = this.qty;
    return data;
  }
}