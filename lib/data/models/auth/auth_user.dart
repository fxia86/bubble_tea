class AuthUserModel {
  String? name;
  String? email;
  String? password;
  int? role;

  AuthUserModel({this.name, this.email, this.password, this.role});

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
    this.password = json['password'];
    this.role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    return data;
  }
}
