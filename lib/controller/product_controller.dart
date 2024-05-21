import 'package:demo_task/constants.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/loader_helpers.dart';

class ProductController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  Constants constants = Constants();

  // UIUtils uiUtils = UIUtils();
  Rx<TextEditingController> quantityController =
      TextEditingController(text: '1').obs;
  RxDouble activeCartTotalPrice = 0.0.obs;
  RxInt activeProductAttributeIndex = 0.obs, // active product attribute index
      activeProductSizeIndex = 0.obs; // active product size index

  Rx<Product>? currentProduct; // active product
  RxList<Product> products = <Product>[].obs; // main product list

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }

  setCurrentProduct({required Product product}) {
    currentProduct = product.obs;
    activeProductAttributeIndex(0);
    activeProductSizeIndex(product.attribute.first.size.first);
  }

  getProducts() async {
    try {
      debugPrint('## getting products list');

      final snapShot = await firebase.collection(constants.products).get();
      // for (var element in snapShot.docs) {
      //   debugPrint(element.data().toString().replaceAll(', ', '\n'));
      // }

      products(snapShot.docs.map((e) => Product.fromSnapShot(e)).toList());
    } catch (e) {
      // uiUtils.showSnackBar(
      //     title: 'Error', message: 'Error getting products.', isError: true);
      debugPrint('## ERROR GETTING PRODUCTS: $e');
    } finally {
      debugPrint('## products list count: ${products.length}');
    }
  }
}
