import 'package:bubble_tea/data/models/base.dart';

class SpecialDiscountModel extends BaseModel {
  String? dishId;
  String? dishName;
  int? discount;

  SpecialDiscountModel({String? id, this.dishId, this.dishName, this.discount})
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


class SpecialPriceModel extends BaseModel {
  String? dishId;
  String? dishName;
  int? oriPrice;
  int? offerPrice;
  String? start;
  String? end;

  SpecialPriceModel({String? id, this.dishId, this.dishName, this.offerPrice})
      : super(id: id);

  SpecialPriceModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.dishName = json['dishName'];
    this.oriPrice = json['oriPrice'];
    this.offerPrice = json['offerPrice'];
    this.start = json['start'];
    this.end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['dishName'] = this.dishName;
    data['oriPrice'] = this.oriPrice;
    data['offerPrice'] = this.offerPrice;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
