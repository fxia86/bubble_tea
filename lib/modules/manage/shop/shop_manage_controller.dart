import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:get/get.dart';

class ShopManageController extends GetxController {
  final ShopRepository repository = Get.find();
  // late ShopDataSource dataSource;

  var showForm = false.obs;
  var isNew = true.obs;

  var items = <ShopModel>[].obs;
  var editItem = ShopModel().obs;
  var keywords = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    items.value = await repository.getAll();
    // dataSource = ShopDataSource();
  }

  @override
  void onClose() {
    // dataSource.dispose();
    super.onClose();
  }

  void add() {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = true;
      editItem.value = ShopModel();
    }
  }

  void edit(String? id) {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = false;
      var item = items.singleWhere((element) => element.id == id);
      editItem.value =
          ShopModel(name: item.name, address: item.address, phone: item.phone);
      editItem.value.id = item.id;
    }
  }

  void deleteConfirm(String? id) {
    final item = items.singleWhere((element) => element.id == id);
    ConfirmBox.show(item.name, () => delete(id));
  }

  void delete(String? id) async {
    if (showForm.value) {
      showForm.value = false;
    }

    final idx = items.indexWhere((element) => element.id == id);
    if (idx > -1) {
      var result = await repository.delete(id);
      if (result) {
        items.removeAt(idx);
      }
    }
  }

  void save() async {
    if (editItem.value.name == null || editItem.value.name!.isEmpty) {
      MessageBox.error('Invalid name');
    } else if (editItem.value.address == null ||
        editItem.value.address!.isEmpty) {
      MessageBox.error('Invalid address');
    } else if (editItem.value.phone == null ||
        editItem.value.phone!.isEmpty ||
        !editItem.value.phone!.isPhoneNumber) {
      MessageBox.error('Invalid phone');
    } else {
      final idx = items.indexWhere((element) =>
          element.name == editItem.value.name &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      if (isNew.value) {
        var item = await repository.add(editItem.value);
        items.insert(0, item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);
        if (item.name == editItem.value.name &&
            item.address == editItem.value.address &&
            item.phone == editItem.value.phone) {
          showForm.value = false;
          return;
        }
        var result = await repository.edit(editItem.value);
        if (result) {
          item
            ..name = editItem.value.name
            ..address = editItem.value.address
            ..phone = editItem.value.phone;
          items.refresh();
        }
      }
      showForm.value = false;
    }
  }
}

// class ShopDataSource extends DataTableSource {
//   final controller = Get.find<ShopManageController>();

//   var selection = Set<int>();

//   @override
//   DataRow? getRow(int index) {
//     return DataRow(cells: [
//       DataCell(
//         Text(
//           (index + 1).toString(),
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       DataCell(
//         Text(
//           controller.shops[index].name!,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       DataCell(
//         Text(
//           controller.shops[index].address!,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       DataCell(
//         Text(
//           controller.shops[index].phone!,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       DataCell(Row(
//         children: [
//           ScaleIconButton(
//             onPressed: () {
//               controller.edit(controller.shops[index].id!);
//             },
//             icon: Icon(Icons.edit),
//             color: Colors.orange,
//           ),
//           ScaleIconButton(
//             onPressed: () {
//               controller.edit(controller.shops[index].id!);
//             },
//             icon: Icon(Icons.delete),
//             color: Colors.red,
//           ),
//         ],
//       )),
//     ]);
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => controller.shops.length;

//   @override
//   int get selectedRowCount => 0;

//   void _sort<T>(
//       Comparable<T> Function(ShopModel model) getField, bool ascending) {
//     controller.shops.sort((a, b) {
//       final aValue = getField(a);
//       final bValue = getField(b);
//       return ascending
//           ? Comparable.compare(aValue, bValue)
//           : Comparable.compare(bValue, aValue);
//     });
//   }
// }
