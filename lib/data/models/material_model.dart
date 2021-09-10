import 'package:bubble_tea/data/models/base.dart';

class MaterialModel extends BaseModel {
  String? name;
  String? code;
  int? stock;
  String? img;
  int? delivery;
  int? warning;

  MaterialModel(
      {String? id,
      this.name,
      this.code,
      this.stock,
      this.img,
      this.delivery,
      this.warning})
      : super(id: id);

  MaterialModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.code = json['code'];
    this.stock = json['stock'];
    this.img = json['img'];
    this.delivery = json['delivery'];
    this.warning = json['warning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['stock'] = this.stock;
    data['img'] = this.img;
    data['delivery'] = this.delivery;
    data['warning'] = this.warning;
    return data;
  }
}

class MaterialStockModel extends BaseModel {
  String? shopName;
  int? qty;

  MaterialStockModel({this.shopName, this.qty});

  MaterialStockModel.fromJson(Map<String, dynamic> json) {
    this.shopName = json['shopName'];
    this.qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['qty'] = this.qty;
    return data;
  }
}

class MaterialStockOrderModel extends BaseModel {
  String? materialId;
  String? shopId;
  String? shopName;
  String? orderDate;
  int? qty;
  String? arrivedDate;
  String? supplierId;
  String? supplierName;

  MaterialStockOrderModel(
      {this.materialId,
      this.shopId,
      this.shopName,
      this.orderDate,
      this.qty,
      this.arrivedDate,
      this.supplierId,
      this.supplierName});

  MaterialStockOrderModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.materialId = json['materialId'];
    this.shopId = json['shopId'];
    this.shopName = json['shopName'];
    this.orderDate = json['orderDate'];
    this.qty = json['qty'];
    this.arrivedDate = json['arrivedDate'];
    this.supplierId = json['supplierId'];
    this.supplierName = json['supplierName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['materialId'] = this.materialId;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['orderDate'] = this.orderDate;
    data['qty'] = this.qty;
    data['arrivedDate'] = this.arrivedDate;
    data['supplierId'] = this.supplierId;
    data['supplierName'] = this.supplierName;
    return data;
  }
}
