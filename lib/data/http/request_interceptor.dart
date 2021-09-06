import 'package:bubble_tea/data/http/http_client.dart';
import 'package:bubble_tea/data/local/local_storage.dart';
import 'package:bubble_tea/data/services/base.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:bubble_tea/utils/loading_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra["showLoading"]) {
      LoadingBox.show();
    }
    // set token
    if (LocalStorage.hasData("authToken")) {
      final token = LocalStorage.getAuthToken();
      options.headers["Authorization"] = 'Bearer ${token.accessToken}';
    }

    debugPrint('''
      *** Request ***
      ${options.method}: ${options.uri}
      Data: ${options.data}
      Query: ${options.queryParameters}
      ***************
      ''');

    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint('''
      *** Response ***
      $response
      ****************
      ''');

    final statusCode = response.statusCode!;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.requestOptions.extra["showLoading"]) {
        LoadingBox.hide();
      }
      handler.next(response);
    } else if (statusCode == 401) {
      // refresh token
      HttpClient.instance.dio.lock();

      final dio = HttpClient().newInstance();
      final refreshed = await dio.post("${ServiceUrl.AUTH}/refresh",
          data: LocalStorage.getAuthToken());

      debugPrint('''
        *** Refresh ***
        $refreshed
        ****************
        ''');

      HttpClient.instance.dio.unlock();

      // if refreshed successfully, redo last request
      // else go to login
      if (refreshed.statusCode == 200) {
        LocalStorage.setAuthInfo(refreshed.data);

        dio.options
          ..method = response.requestOptions.method
          ..headers["Authorization"] =
              'Bearer ${refreshed.data["token"]["accessToken"]}';

        try {
          if (response.requestOptions.data is FormData) {
            // https://github.com/flutterchina/dio/issues/482
            FormData formData = FormData();
            formData.fields.addAll(response.requestOptions.data.fields);
            for (MapEntry mapFile in response.requestOptions.data.files) {
              final filePath = formData.fields
                  .firstWhere((element) =>
                      element.key == mapFile.key.replaceAll("file_", ""))
                  .value;
              formData.files.add(MapEntry(
                  mapFile.key,
                  MultipartFile.fromFileSync(filePath,
                      filename: mapFile.value.filename)));
            }
            response.requestOptions.data = formData;
          }

          final _response = await dio.request(
            response.requestOptions.path,
            data: response.requestOptions.data,
            queryParameters: response.requestOptions.queryParameters,
          );

          debugPrint('''
          *** Response After Refresh***
          $_response
          ****************
        ''');

          if (response.requestOptions.extra["showLoading"]) {
            LoadingBox.hide();
          }

          if (_response.statusCode! >= 200 && _response.statusCode! < 300) {
            handler.next(_response);
          } else {
            MessageBox.error(response.data ?? "Some error occurred ");
          }
        } catch (e) {
          if (response.requestOptions.extra["showLoading"]) {
            LoadingBox.hide();
          }
        }
      } else {
        GET.Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      if (response.requestOptions.extra["showLoading"]) {
        LoadingBox.hide();
      }
      MessageBox.error(response.data ?? "Some error occurred ");
    }
    // super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra["showLoading"]) {
      LoadingBox.hide();
    }
    debugPrint('''
      *** Error ***
      $err
      *************
      ''');
    // MessageBox.error(err.message);
    MessageBox.error("An error occurred.", "Please try again later.");

    return super.onError(err, handler);
  }
}
