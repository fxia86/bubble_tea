import 'package:bubble_tea/data/models/base.dart';

class CatalogModel extends BaseModel {
  String? name;
  int? serial;

  CatalogModel({this.name, this.serial = 0});

  CatalogModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.serial = json['serial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['serial'] = this.serial;
    return data;
  }
}
