import 'package:bubble_tea/data/http/http_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> initServices() async {
  GetStorage.init();
  Get.lazyPut(() => HttpClient());
}

class HttpService extends GetxService {
  HttpClient init() {
    return HttpClient.instance;
  }
}
