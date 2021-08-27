import 'package:bubble_tea/data/models/addition_model.dart';
import 'package:bubble_tea/data/models/base.dart';
import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/printer_model.dart';

class DishModel extends BaseModel {
  String? catalogId;
  String? name;
  int? price;
  String? img;
  String? desc;
  bool? isPopular;

  List<MaterialModel> materials = <MaterialModel>[];
  List<PrinterModel> printers = <PrinterModel>[];
  List<AdditionOptionModel> options = <AdditionOptionModel>[];

  DishModel({
    String? id,
    this.catalogId,
    this.name,
    this.price,
    this.img,
    this.desc,
    this.isPopular = false,
  }):super(id: id);

  DishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.catalogId = json['catalogId'];
    this.name = json['name'];
    this.price = json['price'];
    this.img = json['img'];
    this.desc = json['desc'];
    this.isPopular = json['isPopular'];
    if (json['materials'] != null) {
      this.materials = List.castFrom(json['materials'])
          .map((v) => MaterialModel.fromJson(v))
          .toList();
    }
    if (json['printers'] != null) {
      this.printers = List.castFrom(json['printers'])
          .map((v) => PrinterModel.fromJson(v))
          .toList();
    }
    if (json['options'] != null) {
      this.options = List.castFrom(json['options'])
          .map((v) => AdditionOptionModel.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catalogId'] = this.catalogId;
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
