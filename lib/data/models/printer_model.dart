import 'package:bubble_tea/data/models/base.dart';

class PrinterModel extends BaseModel {
  String? name;
  String? address;
  String? alias;

  PrinterModel({this.name, this.address, this.alias});

  PrinterModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.address = json['address'];
    this.alias = json['alias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['alias'] = this.alias;
    return data;
  }
}
