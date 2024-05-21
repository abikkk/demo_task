import 'package:demo_task/constants.dart';
import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:demo_task/model/product_review_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  RxBool productsLoaded = false.obs;

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
    productsLoaded(false);
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

      ReceiptController receiptController = Get.find<ReceiptController>();
      await receiptController.getReceipts();
      await receiptController.getProductReview();
      assignRatingAndReview();
      productsLoaded(true);
    }
  }

  assignRatingAndReview() async {
    ReceiptController receiptController = Get.find<ReceiptController>();
    for (var product in products) {
      int rating = 0, totalReviews = 0;
      List<ProductReview> productReviews = receiptController.productReviews
          .where(
              (p0) => p0.productId.toLowerCase() == product.name.toLowerCase())
          .toList();
      totalReviews = productReviews.length;
      if (totalReviews == 0) {
        product.rating = rating.toDouble();
        product.reviews = totalReviews;
      } else {
        for (var reviews in productReviews) {
          rating = reviews.rating + rating;
        }
        product.rating = rating / totalReviews;
        product.reviews = totalReviews;
      }
    }
  }
}
