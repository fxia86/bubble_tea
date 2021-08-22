import 'package:bubble_tea/data/http/http_client.dart';

class ShopService {
  Future<Object> getAll() async {
    final result = await HttpClient.instance.get("path");
    return result;
  }
}