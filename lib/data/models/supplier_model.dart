import 'package:bubble_tea/data/models/base.dart';

class SupplierModel extends BaseModel {
  String? name;
  String? email;
  String? phone;

  SupplierModel({this.name, this.email, this.phone});

  SupplierModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
