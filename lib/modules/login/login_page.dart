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
          Image.asset(R.ImageLoginBg,
              width: context.width, fit: BoxFit.fitWidth),
          Container(
            color: Colors.black45,
            width: context.width,
            height: context.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: Get.textTheme.headline2?.copyWith(color: Colors.white),
                ),
                SizedBox(height: 40),
                EmailField(onChanged: controller.onEmailChanged),
                SizedBox(height: 10),
                PasswordField(onChanged: controller.onPasswordChanged),
                SizedBox(height: 30),
                LoginButton(
                  onLogin: controller.onLogin,
                ),
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
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: context.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
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
        // keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Email",
          icon: Icon(Icons.email),
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
          decoration: InputDecoration(
            hintText: "Password",
            icon: Icon(Icons.lock),
            suffixIcon: IconButton(
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
    return ElevatedButton(
      onPressed: onLogin,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Text(
          "Sign in",
        ),
      ),
    );
  }
}
