import 'package:bubble_tea/data/http/http_client.dart';
import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/data/services/base.dart';

class AuthService {
  login(String email, String password) async {
    var response = await http.post(
      "${ServiceUrl.AUTH}/login",
      data: {"email": email, "password": password},
    );

    LocalStorage.setAuthInfo(response);

    return response;
  }

  modify(String originPwd, String newPwd) async {
    var response = await http.post(
      "${ServiceUrl.AUTH}/modify",
      data: {"originPwd": originPwd, "newPwd": newPwd},
    );

    return response;
  }

  refreshToken() async {
    final dio = HttpClient().newInstance();
    var response = await dio.post("${ServiceUrl.AUTH}/refresh",
        data: LocalStorage.getAuthToken());

    if (response.statusCode == 200) {
      LocalStorage.setAuthInfo(response.data);
      return true;
    } else {
      return false;
    }
  }
}
