import 'package:bubble_tea/data/repositories/auth_repository.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_icon_button.dart';

class ModifyPassword extends StatefulWidget {
  const ModifyPassword({Key? key}) : super(key: key);

  @override
  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  String originPwd = "";
  String newPwd = "";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "Modify Password",
        style: Get.textTheme.headline3,
      ),
      children: [
        Container(
          width: Get.width * 0.3,
          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Column(
            children: [
              PasswordField(
                labelText: "Origin Password",
                onChanged: (val) {
                  setState(() {
                    originPwd = val.trim();
                  });
                },
              ),
              SizedBox(height: 30),
              PasswordField(
                labelText: "New Password",
                onChanged: (val) {
                  setState(() {
                    newPwd = val.trim();
                  });
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (newPwd.isEmpty || originPwd.isEmpty) return;
                  if (newPwd == originPwd) {
                    MessageBox.error(
                        "The new password cannot be the same as the original password ");
                    return;
                  }
                  if (newPwd.length >= 6 && originPwd.length >= 6) {
                    var result =
                        await AuthRepository().modify(originPwd, newPwd);
                    Get.back();
                    if (result) {
                      MessageBox.success();
                    } else {
                      MessageBox.error("Failed", "Incorrect original password");
                    }
                  } else {
                    MessageBox.error("Password length must be greater than 6 ");
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  PasswordField({Key? key, required this.labelText, required this.onChanged})
      : super(key: key);
  final String labelText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
      initialValue: true,
      builder: (value, updateFn) => TextFormField(
        obscureText: value!,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          // contentPadding: EdgeInsets.all(0),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 20),
          suffixIcon: ScaleIconButton(
            onPressed: () => updateFn(!value),
            icon: Icon(value ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
