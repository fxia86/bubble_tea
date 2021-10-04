class AuthUserModel {
  String? name;
  String? email;
  String? shopId;
  String? shopName;
  String? shopAddress;
  String? shopPhone;
  String? merchantName;
  int? role;

  AuthUserModel(
      {this.name,
      this.email,
      this.shopId,
      this.shopName,
      this.merchantName,
      this.role});

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
    this.shopId = json['shopId'];
    this.shopName = json['shopName'];
    this.shopAddress = json['shopAddress'];
    this.shopPhone = json['shopPhone'];
    this.merchantName = json['merchantName'];
    this.role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['shopAddress'] = this.shopAddress;
    data['shopPhone'] = this.shopPhone;
    data['merchantName'] = this.merchantName;
    data['role'] = this.role;
    return data;
  }
}
