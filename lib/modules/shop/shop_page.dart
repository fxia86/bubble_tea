import 'package:bubble_tea/modules/shop/shop_controller.dart';
import 'package:bubble_tea/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends GetView<ShopController> {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Obx(() => controller.orderList.length > 0
                ? Material(
                    elevation: 10,
                    child: Container(
                      width: context.width * 0.25,
                      child: OrderList(),
                    ),
                  )
                : SizedBox()),
            Expanded(
              child: Menu(),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  OrderList({Key? key}) : super(key: key);

  final controller = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: context.width * 0.25,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
          ),
          child: Text(
            'Order List',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue[300],
            child: Obx(() => Scrollbar(
                    child: ListView.separated(
                  itemCount: controller.orderList.length,
                  itemBuilder: (context, index) {
                    return OrderItem(item: controller.orderList[index]);
                  },
                  separatorBuilder: (context, i) =>
                      Divider(color: Colors.white),
                  // itemExtent: 60,
                ))),
          ),
        ),
        Divider(
          color: Colors.white,
          height: 0,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          width: context.width,
          padding: EdgeInsets.all(20),
          color: Colors.blue[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black87),
              ),
              Obx(() => Text(
                    '€ ${(controller.totalPrice / 100).toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.black87),
                  )),
            ],
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: controller.place,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Place order',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class OrderItem extends StatelessWidget {
  OrderItem({Key? key, required this.item}) : super(key: key);
  final controller = Get.find<ShopController>();
  final OrderModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuItemTitle(
                  text: item.dish.name,
                  fontSize: 28,
                ),
                MenuItemTitle(text: item.dish.desc),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                ScaleIconButton(
                  // padding: EdgeInsets.all(0),
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () => controller.remove(item),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Obx(() => Text(item.count.toString(),
                      style: TextStyle(fontSize: 30))),
                ),
                ScaleIconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => controller.add(item),
                ),
              ],
            ),
            Obx(() => MenuItemTitle(
                  text:
                      "€ ${(item.dish.price * item.count.value / 100).toStringAsFixed(2)}",
                  // fontSize: 28,
                )),
          ],
        )
      ],
    );
  }
}

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);

  final controller = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 10,
          child: Container(
            width: context.width,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              labelStyle: Theme.of(context).textTheme.headline5,
              indicatorColor: Colors.white,
              unselectedLabelStyle: Theme.of(context).textTheme.headline6,
              indicatorWeight: 3,
              tabs: [for (var item in controller.catalogs) Tab(text: item)],
            ),
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              for (var _ in controller.catalogs)
                Obx(() => MenuGrid(
                      list: controller.popList,
                      crossAxisCount: controller.orderList.length > 0 ? 2 : 3,
                    ))
            ],
          ),
        ),
      ],
    );
  }
}

class MenuGrid extends StatelessWidget {
  MenuGrid({Key? key, required this.list, this.crossAxisCount = 2})
      : super(key: key);

  final list;
  final crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.5,
      padding: EdgeInsets.all(20),
      children: [for (var item in list) MenuItem(item: item)],
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({Key? key, required this.item}) : super(key: key);

  final controller = Get.find<ShopController>();

  final DishModel item;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          item.picture,
          fit: BoxFit.cover,
        ),
      ),
      footer: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
        clipBehavior: Clip.antiAlias,
        child: GridTileBar(
          backgroundColor: Colors.black45,
          title: MenuItemTitle(
              text:
                  "${item.name}     € ${(item.price / 100).toStringAsFixed(2)}",
              fontSize: 28),
          subtitle: 1 == 1 ? MenuItemTitle(text: item.desc) : null,
          trailing: FloatingActionButton(
            onPressed: () => controller.order(item),
            child: Icon(
              Icons.add,
              size: 32,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class MenuItemTitle extends StatelessWidget {
  const MenuItemTitle({Key? key, required this.text, this.fontSize = 20})
      : super(key: key);
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
