// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

class ConnectInterceptor extends Interceptor {
  // final Connectivity _connectivity = Connectivity();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // ConnectivityResult connectivityResult =
    //     await _connectivity.checkConnectivity();

    // if (connectivityResult == ConnectivityResult.mobile) {
    //   debugPrint('''
    //     ======================
    //     *** Connectivity ***
    //     $connectivityResult
    //     ''');
    //   // I am connected to a mobile network.
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   debugPrint('''
    //     ======================
    //     *** Connectivity ***
    //     $connectivityResult
    //     ''');
    //   // I am connected to a wifi network.
    // } else{
    //   debugPrint('''
    //     ======================
    //     *** Connectivity ***
    //     no network!!!
    //     ''');
    // }
    
    super.onRequest(options, handler);
  }
}
