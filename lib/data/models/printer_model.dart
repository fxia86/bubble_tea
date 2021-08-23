import 'package:bubble_tea/data/models/base.dart';

class PrinterModel extends BaseModel {
  String? shopId;
  String? shopName;
  String? name;
  String? address;
  String? alias;

  PrinterModel({this.name, this.address, this.alias, this.shopId, this.shopName});

  PrinterModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.shopId = json['shopId'];
    this.shopName = json['shopName'];
    this.name = json['name'];
    this.address = json['address'];
    this.alias = json['alias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['name'] = this.name;
    data['address'] = this.address;
    data['alias'] = this.alias;
    return data;
  }
}
