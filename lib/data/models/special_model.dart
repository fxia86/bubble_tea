import 'package:bubble_tea/data/models/base.dart';

class SpecialDiscountModel extends BaseModel {
  String? dishId;
  String? dishName;
  int? discount;

  SpecialDiscountModel({String? id, this.dishId, this.discount})
      : super(id: id);

  SpecialDiscountModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.dishName = json['dishName'];
    this.discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['dishName'] = this.dishName;
    data['discount'] = this.discount;
    return data;
  }
}

class SpecialBundleModel extends BaseModel {
  int? offerPrice;
  List<BundleDishModel> dishes = <BundleDishModel>[];

  SpecialBundleModel({
    String? id,
    this.offerPrice,
  }) : super(id: id);

  SpecialBundleModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.offerPrice = json['offerPrice'];
    if (json['dishes'] != null) {
      this.dishes = List.castFrom(json['dishes'])
          .map((v) => BundleDishModel.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offerPrice'] = this.offerPrice;
    data['dishes'] = List.castFrom(this.dishes.map((e) => e.toJson()).toList());
    return data;
  }
}

class BundleDishModel extends BaseModel {
  String? bundleId;
  String? dishId;
  String? dishName;
  int? qty;

  BundleDishModel(
      {String? id, this.bundleId, this.dishId, this.dishName, this.qty})
      : super(id: id);

  BundleDishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.bundleId = json['bundleId'];
    this.dishId = json['dishId'];
    this.dishName = json['dishName'];
    this.qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bundleId'] = this.bundleId;
    data['dishId'] = this.dishId;
    data['dishName'] = this.dishName;
    data['qty'] = this.qty;
    return data;
  }
}

class SpecialPriceModel extends BaseModel {
  String? dishId;
  String? dishName;
  int? originalPrice;
  int? offerPrice;
  String? start;
  String? end;

  SpecialPriceModel(
      {String? id, this.dishId, this.offerPrice, this.start, this.end})
      : super(id: id);

  SpecialPriceModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.dishName = json['dishName'];
    this.originalPrice = json['originalPrice'];
    this.offerPrice = json['offerPrice'];
    this.start = json['start'];
    this.end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['dishName'] = this.dishName;
    data['originalPrice'] = this.originalPrice;
    data['offerPrice'] = this.offerPrice;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
