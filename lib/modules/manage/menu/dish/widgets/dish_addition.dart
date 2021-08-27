import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dish_detail_controller.dart';

class AdditionSelection extends StatelessWidget {
  final controller = Get.find<DishDetailController>();

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
        initialValue: false,
        builder: (value, updateFn) {
          return Column(
            children: [
              Container(
                color: Get.theme.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "1. Select additional options",
                      style: Get.textTheme.bodyText1?.copyWith(
                          color:
                              value! ? Colors.black45 : Get.theme.primaryColor),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.navigate_next, color: Colors.black45),
                    SizedBox(width: 20),
                    Text(
                      "2. Set extra price",
                      style: Get.textTheme.bodyText1?.copyWith(
                          color:
                              value! ? Get.theme.primaryColor : Colors.black45),
                    )
                  ],
                ),
              ),
              Expanded(child: value! ? OptionalForm() : AdditionMap()),
              value
                  ? ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateFn(false),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Get.theme.primaryColor)),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Previous',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.saveAddition,
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
                        ),
                      ],
                    )
                  : ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateFn(true),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Next',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          );
        });
  }
}

class AdditionMap extends StatelessWidget {
  final controller = Get.find<DishDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.additions.length,
          itemBuilder: (c, i) {
            final addition = controller.additions[i];

            return Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          color: Get.theme.primaryColor,
                          width: 5,
                          height: 30,
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Text(
                          addition.name ?? "",
                          style: Get.textTheme.bodyText1
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Wrap(spacing: 10, children: [
                    for (var item in addition.options)
                      ValueBuilder<bool?>(
                        initialValue: false,
                        builder: (value, updateFn) {
                          return Chip(
                            label: Text(item.name ?? "",style: Get.textTheme.bodyText1,),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          );
                        },
                        onUpdate: (value) => print('Value updated: $value'),
                      )
                  ]),
                ],
              ),
            );
          }),
    );
  }
}

// class AdditionMap extends StatelessWidget {
//   final controller = Get.find<DishDetailController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: controller.additions.length,
//           itemBuilder: (c, i) {
//             final addition = controller.additions[i];

//             return Container(
//               margin: EdgeInsets.only(top: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(bottom: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           color: Get.theme.primaryColor,
//                           width: 5,
//                           height: 30,
//                           margin: EdgeInsets.only(right: 10),
//                         ),
//                         Text(
//                           addition.name ?? "",
//                           style: Get.textTheme.bodyText1
//                               ?.copyWith(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                   GridView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           mainAxisExtent: 50,
//                           mainAxisSpacing: 20,
//                           crossAxisSpacing: 20),
//                       itemCount: addition.options.length,
//                       itemBuilder: (c, j) {
//                         return Container(
//                           child: ValueBuilder<bool?>(
//                             initialValue: false,
//                             builder: (value, updateFn) {
//                               return Container(
//                                 padding: EdgeInsets.all(0),
//                                 decoration: BoxDecoration(
//                                   color: value!
//                                       ? Get.theme.accentColor
//                                       : Colors.white,
//                                   border: Border.all(
//                                       color: value
//                                           ? Get.theme.primaryColor
//                                           : Colors.black38),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: TextButton(
//                                     onPressed: () => updateFn(!value),
//                                     child: Text(
//                                       addition.options[j].name ?? "",
//                                       style: Get.textTheme.bodyText1?.copyWith(
//                                           color: value
//                                               ? Get.theme.primaryColor
//                                               : Colors.black87),
//                                     )),
//                               );
//                             },
//                             onUpdate: (value) => print('Value updated: $value'),
//                           ),
//                         );
//                       }),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }

class OptionalForm extends StatelessWidget {
  final controller = Get.find<DishDetailController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: context.height,
      padding: EdgeInsets.all(20),
      child: Text("data"),
    );
  }
}
