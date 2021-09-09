import 'package:bubble_tea/app_theme.dart';
import 'package:bubble_tea/init.dart';
import 'package:bubble_tea/modules/login/login_binding.dart';
import 'package:bubble_tea/modules/login/login_page.dart';
import 'package:bubble_tea/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  await initServices();
  runApp(MyApp());

  //状态栏透明
  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightThemeData,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: AppThemeData.textScale), //字体缩放
        child: Scaffold(
          body: GestureDetector(
            child: child,
            onTap: () => hideKeyboard(context), //点空白处收起键盘
          ),
          // resizeToAvoidBottomInset: false, //底部弹出时不改变页面大小
        ),
      ),
      home: LoginPage(),
      initialBinding: LoginBinding(),
      getPages: Pages.pages,
    );
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
