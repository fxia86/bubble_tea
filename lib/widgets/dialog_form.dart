import 'package:flutter/material.dart';

class DialogForm extends StatelessWidget {
  const DialogForm({Key? key, required this.form, this.onWillPop})
      : super(key: key);
  final Widget form;
  final VoidCallback? onWillPop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(onTap: onWillPop),
          ),
          form
        ],
      ),
    );
  }
}
