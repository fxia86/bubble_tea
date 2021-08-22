import 'package:bubble_tea/constant/app_config.dart';
import 'package:dio/dio.dart';

// import 'cache_interceptor.dart';
// import 'connect_interceptor.dart';
import 'request_interceptor.dart';

class HttpClient {
  static const CONNECT_TIMEOUT = 100000;
  static const RECEIVE_TIMEOUT = 100000;

  static HttpClient instance = HttpClient._internal();

  factory HttpClient() => instance;

  Dio dio = Dio();
  CancelToken _cancelToken = new CancelToken();

  HttpClient._internal() {
    dio.options
      ..baseUrl = AppConfig.baseUrl
      ..connectTimeout = CONNECT_TIMEOUT
      ..receiveTimeout = RECEIVE_TIMEOUT
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = {};

    dio.interceptors.add(RequestInterceptor()); //自定义拦截
    // dio.interceptors.add(ConnectInterceptor()); //网络
    // dio.interceptors.add(LogInterceptor()); //日志
    // dio.interceptors.add(CacheInterceptor()); //缓存

    // // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    // if (PROXY_ENABLE) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (uri) {
    //       return "PROXY $PROXY_IP:$PROXY_PORT";
    //     };
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  Dio newInstance() {
    final _dio = Dio();
    _dio.options
      ..baseUrl = AppConfig.baseUrl
      ..connectTimeout = CONNECT_TIMEOUT
      ..receiveTimeout = RECEIVE_TIMEOUT
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = {};
    return _dio;
  }

  // void init(
  //     //这个在main或者初始化的时候先调用一下
  //     {String? baseUrl,
  //     int? connectTimeout,
  //     int? receiveTimeout,
  //     List<Interceptor>? interceptors}) {
  //   dio.options = dio.options.copyWith(
  //     baseUrl: baseUrl,
  //     connectTimeout: connectTimeout,
  //     receiveTimeout: receiveTimeout,
  //   );
  //   if (interceptors != null && interceptors.isNotEmpty) {
  //     dio.interceptors.addAll(interceptors);
  //   }
  // }

  // 设置headers
  void setHeaders(Map<String, dynamic> map) {
    dio.options.headers.addAll(map);
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  // restful get 操作
  Future get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool showLoading = true,
    bool refresh = false,
    bool noCache = true,
    String? cacheKey,
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": showLoading,
      "refresh": refresh,
      "noCache": noCache,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    Response response;
    response = await dio.get(path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful post 操作
  Future post(
    String path, {
    Map<String, dynamic>? params,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var response = await dio.post(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful put 操作
  Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var response = await dio.put(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful patch 操作
  Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    // Map<String, dynamic> _authorization = getAuthorizationHeader();
    // if (_authorization != null) {
    //   requestOptions = requestOptions.merge(headers: _authorization);
    // }
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var response = await dio.patch(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful delete 操作
  Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var response = await dio.delete(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful post form 表单提交操作
  Future postForm(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var data = FormData.fromMap(params!);
    var response = await dio.post(path,
        data: data,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  // restful put form 表单提交操作
  Future putForm(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "showLoading": true,
    });
    var data = FormData.fromMap(params!);
    var response = await dio.put(path,
        data: data,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }
}
