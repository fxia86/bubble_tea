import 'package:bubble_tea/data/models/material_model.dart';
import 'package:bubble_tea/data/models/shop_model.dart';
import 'package:bubble_tea/data/models/supplier_model.dart';
import 'package:bubble_tea/data/repositories/materia_repository.dart';
import 'package:bubble_tea/data/repositories/shop_repository.dart';
import 'package:bubble_tea/data/repositories/supplier_repository.dart';
import 'package:bubble_tea/utils/confirm_box.dart';
import 'package:bubble_tea/utils/message_box.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MaterialManageController extends GetxController {
  final MaterialRepository repository = Get.find();

  var showForm = false.obs;
  var isNew = true.obs;

  var items = <MaterialModel>[].obs;
  var editItem = MaterialModel().obs;
  var shops = <ShopModel>[];
  var suppliers = <SupplierModel>[];
  var keywords = "".obs;

  var stocks = <MaterialStockModel>[].obs;
  var stockOrders = <MaterialStockOrderModel>[].obs;
  var newOrder = MaterialStockOrderModel().obs;

  final _picker = ImagePicker();
  XFile? _image;
  var imagePath = "".obs;

  @override
  void onReady() async {
    super.onReady();

    print("material");

    items.value = await repository.getAll();
    Get.find<ShopRepository>()
        .getAll(showLoading: false)
        .then((value) => shops = value);
    Get.find<SupplierRepository>()
        .getAll(showLoading: false)
        .then((value) => suppliers = value);
  }

  void pickImage(int source) async {
    _image = await _picker.pickImage(
      source: source == 1 ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 400,
      // maxHeight: maxHeight,
      // imageQuality: quality,
    );
    if (_image != null) {
      imagePath.value = _image!.path;
      editItem.value.img = imagePath.value;
    }
  }

  void add() {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = true;
      imagePath.value = "";
      editItem.value = MaterialModel();
    }
  }

  void edit(String? id) {
    if (showForm.value) {
      showForm.value = false;
    } else {
      showForm.value = true;
      isNew.value = false;
      imagePath.value = "";
      var item = items.singleWhere((element) => element.id == id);
      editItem.value = MaterialModel(
          name: item.name,
          img: item.img,
          delivery: item.delivery,
          warning: item.warning);
      editItem.value.id = item.id;
    }
  }

  detail(String? id) async {
    var item = items.singleWhere((element) => element.id == id);
    editItem.value = MaterialModel(
        name: item.name,
        img: item.img,
        delivery: item.delivery,
        warning: item.warning);
    editItem.value.id = item.id;

    stocks.value = await repository.getStocks(item.id, showLoading: false);

    stockOrders.value = await repository.getStockOrders(item.id);
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
    } else if (editItem.value.delivery == null ||
        editItem.value.delivery! <= 0) {
      MessageBox.error(
          'Invalid delivery time', 'It should be a positive integer.');
    } else if (editItem.value.warning == null || editItem.value.warning! <= 0) {
      MessageBox.error(
          'Invalid warning time', 'It should be a positive integer.');
    } else {
      final idx = items.indexWhere((element) =>
          element.name == editItem.value.name &&
          element.id != editItem.value.id);
      if (idx > -1) {
        MessageBox.error('Duplicated Name');
        return;
      }
      var data = editItem.value.toJson();
      if (imagePath.value.isNotEmpty) {
        data["file_img"] = await dio.MultipartFile.fromFile(imagePath.value);
      }
      if (isNew.value) {
        if (imagePath.value.isEmpty) {
          MessageBox.error('No image found');
          return;
        }
        var item = await repository.add(data);
        items.insert(0, item);
      } else {
        var item =
            items.singleWhere((element) => element.id == editItem.value.id);
        if (imagePath.value.isEmpty &&
            item.name == editItem.value.name &&
            item.delivery == editItem.value.delivery &&
            item.warning == editItem.value.warning) {
          showForm.value = false;
          return;
        }
        var result = await repository.edit(data);

        item
          ..name = result.name
          ..img = result.img
          ..delivery = result.delivery
          ..warning = result.warning;
        items.refresh();
      }
      showForm.value = false;
    }
  }

  void initOrder() {
    newOrder.value = MaterialStockOrderModel(materialId: editItem.value.id);
  }

  void selectShop(ShopModel item) {
    newOrder.value.shopId = item.id;
    newOrder.value.shopName = item.name;
    newOrder.refresh();
  }

  void selectSupplier(SupplierModel item) {
    newOrder.value.supplierId = item.id;
    newOrder.value.supplierName = item.name;
    newOrder.refresh();
  }

  addOrder() async {
    if (newOrder.value.shopId == null || newOrder.value.shopId!.isEmpty) {
      MessageBox.error('Please select a shop');
    } else if (newOrder.value.supplierId == null ||
        newOrder.value.supplierId!.isEmpty) {
      MessageBox.error('Please select a supplier');
    } else {
      newOrder.value.arrivedDate = DateTime.now().toString().substring(0, 10);
      newOrder.value.orderDate = DateTime.now()
          .subtract(Duration(days: editItem.value.delivery!))
          .toString()
          .substring(0, 10);
      var result = await repository.addOrder(newOrder.value);

      if (result) {
        stockOrders.insert(0, newOrder.value);

        var stock = stocks.singleWhere(
            (element) => element.shopName == newOrder.value.shopName);
        stock.qty = stock.qty! + newOrder.value.qty!;
        stocks.refresh();
      }
    }
  }
}
