import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUtils {
  static int getMoney(String val) {
    if (val.isNum) {
      final idx = val.indexOf(".");
      if (idx > -1) {
        return int.parse(val.padRight(idx + 3, "0").replaceAll(".", ""));
      } else {
        return int.parse(val) * 100;
      }
    }
    return 0;
  }

  static DateTime? toDateTime(String val) {
    if (val.isDateTime) {
      return DateTime.parse(val);
    } else if (RegExp(
            r'^\d{4}[-/]\d{1,2}[-/]\d{1,2}[ T]\d{1,2}:\d{1,2}:\d{1,2}(.\d{3})?Z?$')
        .hasMatch(val)) {
      final arr = val.split(RegExp(r"[ T.]"));
      final ymd =
          arr[0].split(RegExp(r"[-/]")).map((e) => e.padLeft(2, "0")).join("-");
      final hms = arr[1].split(":").map((e) => e.padLeft(2, "0")).join(":");
      final ms = arr.length > 2 ? arr[3] : "000";
      return DateTime.parse("$ymd $hms.$ms");
    }
    return null;
  }

  static DateTime? toDate(String val) {
    var datetime = toDateTime(val);
    if (datetime != null) {
      return DateUtils.dateOnly(datetime);
    }
    return datetime;
  }

  static String? toDateString(String val) {
    if (RegExp(
            r'^\d{4}[-/]\d{1,2}[-/]\d{1,2}[ T]\d{1,2}:\d{1,2}:\d{1,2}(.\d{3})?Z?$')
        .hasMatch(val)) {
      return val
          .split(RegExp(r"[ T.]"))[0]
          .split(RegExp(r"[-/]"))
          .map((e) => e.padLeft(2, "0"))
          .join("-");
    }
    return null;
  }
}
