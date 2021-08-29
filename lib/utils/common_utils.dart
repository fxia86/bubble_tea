import 'package:get/get.dart';

class CommonUtils {
  static int getMoney(String val) {
    if (val.isNum) {
      final idx = val.indexOf(".");
      if (idx > -1) {
        return int.parse(val.padRight(idx + 3,"0").replaceAll(".", ""));
      } else {
        return int.parse(val) * 100;
      }
    }
    return 0;
  }
}
