import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble_tea/r.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Image.asset(R.LOGIN_BG, width: context.width, fit: BoxFit.fitWidth),
          Container(
            // color: Colors.black45,
            width: context.width,
            height: context.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'WELCOME',
                  style: TextStyle(fontSize: 48, letterSpacing: 5),
                ),
                SizedBox(height: 70),
                EmailField(onChanged: controller.onEmailChanged),
                SizedBox(height: 40),
                PasswordField(onChanged: controller.onPasswordChanged),
                SizedBox(height: 70),
                LoginButton(
                  onLogin: controller.onLogin,
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: Get.textTheme.bodyText1
                          ?.copyWith(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget? child;
  const TextFieldContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: context.width * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // color: Colors.white,
          border: Border.all(color: Colors.white)),
      child: child,
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: Get.textTheme.headline5?.copyWith(color: Colors.white),
        // keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          hintText: "Email",
          hintStyle: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
          icon: Icon(
            Icons.email,
            size: Get.theme.iconTheme.size,
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    this.onChanged,
    this.obscureChanged,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final VoidCallback? obscureChanged;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: ValueBuilder<bool?>(
        initialValue: true,
        builder: (value, updateFn) => TextField(
          obscureText: value!,
          style: Get.textTheme.headline5?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
            icon: Icon(Icons.lock, size: Get.theme.iconTheme.size),
            suffixIcon: ScaleIconButton(
              onPressed: () => updateFn(!value),
              icon: Icon(value ? Icons.visibility : Icons.visibility_off),
            ),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
        // if you need to call something outside the builder method.
        // onUpdate: (value) => print('Value updated: $value'),
        // onDispose: () => print('Widget unmounted'),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, this.onLogin}) : super(key: key);

  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.3,
      height: 60,
      child: ElevatedButton(
        onPressed: onLogin,
        child: Center(
          child: Text(
            "Sign in",
            style: Get.textTheme.headline5?.copyWith(color: Colors.white),
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
        ),
      ),
    );
  }
}
