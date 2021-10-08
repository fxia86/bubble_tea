import 'package:bubble_tea/data/models/base.dart';

class DishModel extends BaseModel {
  String? catalogId;
  String? name;
  String? code;
  int? price;
  String? img;
  String? desc;
  bool? isPopular;
  int? serial;

  List<DishMaterialModel> materials = <DishMaterialModel>[];
  List<DishPrinterModel> printers = <DishPrinterModel>[];
  List<DishOptionModel> options = <DishOptionModel>[];

  DishModel({
    String? id,
    this.catalogId,
    this.name,
    this.code,
    this.price = 0,
    this.img,
    this.desc,
    this.isPopular = false,
    this.serial = 0,
  }) : super(id: id);

  DishModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.catalogId = json['catalogId'];
    this.name = json['name'];
    this.code = json['code'];
    this.price = json['price'];
    this.img = json['img'];
    this.desc = json['desc'];
    this.isPopular = json['isPopular'];
    this.serial = json['serial'];
    if (json['materials'] != null) {
      this.materials = List.castFrom(json['materials'])
          .map((v) => DishMaterialModel.fromJson(v))
          .toList();
    }
    if (json['printers'] != null) {
      this.printers = List.castFrom(json['printers'])
          .map((v) => DishPrinterModel.fromJson(v))
          .toList();
    }
    if (json['options'] != null) {
      this.options = List.castFrom(json['options'])
          .map((v) => DishOptionModel.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catalogId'] = this.catalogId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['price'] = this.price;
    data['img'] = this.img;
    data['desc'] = this.desc;
    data['isPopular'] = this.isPopular;
    data['serial'] = this.serial;
    return data;
  }
}

class DishMaterialModel extends BaseModel {
  String? dishId;
  String? materialId;
  String? materialName;
  int? qty;

  DishMaterialModel(
      {String? id, this.dishId, this.materialId, this.materialName, this.qty})
      : super(id: id);

  DishMaterialModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.materialId = json['materialId'];
    this.materialName = json['materialName'];
    this.qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['materialId'] = this.materialId;
    data['materialName'] = this.materialName;
    data['qty'] = this.qty;
    return data;
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is DishMaterialModel &&
  //         this.id == other.id &&
  //         this.dishId == other.materialName &&
  //         this.qty == other.qty;

  // int get hashCode => id.hashCode;
}

class DishPrinterModel extends BaseModel {
  String? dishId;
  String? printerId;

  DishPrinterModel({String? id, this.dishId, this.printerId}) : super(id: id);

  DishPrinterModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.printerId = json['printerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['printerId'] = this.printerId;
    return data;
  }
}

class DishOptionModel extends BaseModel {
  String? dishId;
  String? additionId;
  String? additionName;
  String? optionId;
  String? optionName;
  String? materialId;
  int? qty;
  int? price;

  DishOptionModel(
      {String? id,
      this.dishId,
      this.additionId,
      this.additionName,
      this.optionId,
      this.optionName,
      this.materialId,
      this.qty,
      this.price = 0})
      : super(id: id);

  DishOptionModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dishId = json['dishId'];
    this.additionId = json['additionId'];
    this.additionName = json['additionName'];
    this.optionId = json['optionId'];
    this.optionName = json['optionName'];
    this.materialId = json['materialId'];
    this.qty = json['qty'];
    this.price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dishId'] = this.dishId;
    data['additionId'] = this.additionId;
    data['additionName'] = this.additionName;
    data['optionId'] = this.optionId;
    data['optionName'] = this.optionName;
    data['materialId'] = this.materialId;
    data['qty'] = this.qty;
    data['price'] = this.price;
    return data;
  }
}
