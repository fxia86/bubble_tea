class AuthTokenModel {
  String? accessToken;
  String? refreshToken;

  AuthTokenModel({this.accessToken, this.refreshToken});

  AuthTokenModel.fromJson(Map<String, dynamic> json) {
    this.accessToken = json['accessToken'];
    this.refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
