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
          Obx(() => controller.forgot.value ? ForgotFrom() : LoginForm())
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            label: "Sign in",
            onLogin: controller.onLogin,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () => controller.forgot(true),
            child: Text(
              "Forgot password?",
              style: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class ForgotFrom extends StatelessWidget {
  ForgotFrom({Key? key}) : super(key: key);
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
              if (!controller.sended.value)
                EmailField(onChanged: controller.onEmailChanged),
              if (!controller.sended.value)
                Container(
                  height: 100,
                  width: Get.width * 0.3,
                  child: Center(
                    child: Text(
                      " You will receive a verification code. \n And then you can use the verification code and a new password to log in.",
                      style: Get.textTheme.bodyText1
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (controller.sended.value)
                VerifyCodeField(onChanged: controller.onCodeChanged),
              if (controller.sended.value) SizedBox(height: 40),
              if (controller.sended.value)
                PasswordField(onChanged: controller.onPasswordChanged),
              SizedBox(height: 70),
              if (controller.sended.value)
                LoginButton(
                  label: "Sign in",
                  onLogin: controller.onModifyLogin,
                )
              else
                LoginButton(
                  label: "Send verify code",
                  onLogin: controller.onSend,
                ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => controller.forgot(false),
                child: Text(
                  "Back to Login",
                  style: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ));
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
  EmailField({Key? key, required this.onChanged}) : super(key: key);

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
  PasswordField({
    Key? key,
    this.onChanged,
    this.obscureChanged,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final VoidCallback? obscureChanged;

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: ValueBuilder<bool?>(
        initialValue: true,
        builder: (value, updateFn) => TextField(
          obscureText: value!,
          style: Get.textTheme.headline5?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: controller.forgot.value ? "New Password" : "Password",
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
  const LoginButton({Key? key, this.onLogin, required this.label})
      : super(key: key);

  final VoidCallback? onLogin;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.3,
      height: 60,
      child: ElevatedButton(
        onPressed: onLogin,
        child: Center(
          child: Text(
            label,
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

class VerifyCodeField extends StatelessWidget {
  VerifyCodeField({Key? key, required this.onChanged, this.onSend})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: Get.textTheme.headline5?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          hintText: "Verify Code",
          hintStyle: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
          icon: Icon(
            Icons.pin,
            size: Get.theme.iconTheme.size,
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
