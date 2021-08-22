import 'package:bubble_tea/data/models/base.dart';

class StaffModel extends BaseModel {
  String? shopId;
  String? shopName;
  String? name;
  String? email;
  String? phone;

  StaffModel({this.name, this.shopId, this.shopName, this.email, this.phone});

  StaffModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.shopId = json['shopId'];
    this.shopName = json['shopName'];
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
