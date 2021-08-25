import 'package:bubble_tea/data/models/base.dart';

class AdditionModel extends BaseModel {
  String? name;
  List<AdditionOptionModel> options = <AdditionOptionModel>[];

  AdditionModel({String? id, this.name}) : super(id: id);

  AdditionModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    if (json['options'] != null) {
      this.options = List.castFrom(json['options'])
          .map((v) => AdditionOptionModel.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // if (this.options != null) {
    //   data['options'] = List.from(this.options!.map((o) => o.toJson()));
    // }
    return data;
  }
}

class AdditionOptionModel extends BaseModel {
  String? additionId;
  String? name;

  AdditionOptionModel({String? id, this.additionId, this.name}) : super(id: id);

  AdditionOptionModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.additionId = json['additionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['additionId'] = this.additionId;
    return data;
  }
}
