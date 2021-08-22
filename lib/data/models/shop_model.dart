import 'package:bubble_tea/data/models/base.dart';

class ShopModel extends BaseModel {
  String? name;
  String? address;
  String? phone;

  ShopModel({this.name, this.address, this.phone});

  ShopModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.address = json['address'];
    this.phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
