import 'package:bubble_tea/data/models/auth/auth_token.dart';
import 'package:bubble_tea/data/models/auth/auth_user.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

class LocalStorage {
  static bool hasData(String key) {
    return box.hasData(key);
  }

  static void setAuthInfo(Map<String, dynamic> value) {
    if (value["token"] != null) {
      box.write("authToken", value["token"]);
    }
    if (value["user"] != null) {
      box.write("authUser", value["user"]);
    }
  }

  static void clearAuthInfo() {
    if (hasData("authToken")) {
      box.remove("authToken");
    }
    if (hasData("authUser")) {
      box.remove("authUser");
    }
  }

  static AuthTokenModel getAuthToken() {
    return AuthTokenModel.fromJson(box.read("authToken"));
  }

  static AuthUserModel getAuthUser() {
    return AuthUserModel.fromJson(box.read("authUser"));
  }

  static void setNaviBarcollapsed(bool val) {
    box.write("collapsed", val);
  }

  static bool getNaviBarcollapsed() {
    return box.read("collapsed") ?? false;
  }
}
