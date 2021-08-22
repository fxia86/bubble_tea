import 'package:bubble_tea/data/models/base.dart';

class DishModel extends BaseModel {
  String? catalogId;
  String? catalogName;
  String? name;
  int? price;
  String? img;
  String? desc;
  bool? isPopular;

  DishModel({
    this.catalogId,
    this.catalogName,
    this.name,
    this.price,
    this.img,
    this.desc,
    this.isPopular = false,
  });

  DishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.catalogId = json['catagoryId'];
    this.catalogName = json['catagoryName'];
    this.name = json['name'];
    this.price = json['price'];
    this.img = json['img'];
    this.desc = json['desc'];
    this.isPopular = json['isPopular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catagoryId'] = this.catalogId;
    data['catagoryName'] = this.catalogName;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['desc'] = this.desc;
    data['isPopular'] = this.isPopular;
    return data;
  }
}

class DishMaterialModel extends BaseModel {
  String? dishId;
  String? materialName;
  int? qty;

  DishMaterialModel({this.dishId, this.materialName, this.qty});

  DishMaterialModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.materialName = json['name'];
    this.qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['name'] = this.materialName;
    data['qty'] = this.qty;
    return data;
  }
}
