import 'package:bubble_tea/data/models/base.dart';

class UserModel extends BaseModel {
  String? merchantId;
  String? merchantName;
  String? shopId;
  String? shopName;
  int? role;
  String? name;
  String? email;
  String? phone;

  UserModel({
    String? id,
    this.merchantId,
    this.merchantName,
    this.shopId,
    this.shopName,
    this.role,
    this.name,
    this.email,
    this.phone,
  }) : super(id: id);

  UserModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.merchantId = json['merchantId'];
    this.merchantName = json['merchantName'];
    this.shopId = json['shopId'];
    this.shopName = json['shopName'];
    this.role = json['role'];
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
