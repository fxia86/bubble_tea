import 'package:bubble_tea/modules/manage/special/bundle/bundle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BundlePage extends GetView<BundleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Special offer - Buy 1 get 1",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  CatalogList(),
                  Expanded(child: Column(
                    children: [
                      DishList(),
                      Divider(),
                      DiscountForm()
                    ],
                  )),
                ],
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}

class CatalogList extends StatelessWidget {
  const CatalogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DishList extends StatelessWidget {
  const DishList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class DiscountForm extends StatelessWidget {
  const DiscountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(),
    );
  }
}
