import 'dart:math';
import 'package:demo_task/constants.dart';
import 'package:demo_task/controller/product_controller.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../model/product_review_model.dart';
import '../view/dashboard_screen.dart';
import '../view/loader_helpers.dart';
import '../view/ui_helpers.dart';
import 'cart_controller.dart';

class ReceiptController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  CartController cartController = Get.find<CartController>();
  Constants constants = Constants();
  RxInt userRating = 0.obs, reviewIndex = (0).obs;
  Rx<TextEditingController> userReview = TextEditingController().obs;

  RxList<Receipt> receipts = <Receipt>[].obs;
  Rx<Receipt>? activeReceipt;
  RxList<ProductReview> productReviews = <ProductReview>[].obs;
  RxBool receiptsLoaded = false.obs;

  RxInt? userId;

  createNewUser({int? user}) {
    if (user == null) {
      userId = 0.obs;
      userId!(Constants().userId[Random().nextInt(Constants().userId.length)]);
    } else {
      userId!(user);
    }
  }

  getReceipts() async {
    receiptsLoaded(false);
    try {
      debugPrint('## getting receipts list');

      final snapShot = await firebase
          .collection(constants.receipts)
          .doc(userId!.value.toString())
          .collection(constants.receipts)
          .get();

      receipts(snapShot.docs.map((e) => Receipt.fromSnapshot(e)).toList());
    } catch (e) {
      // uiUtils.showSnackBar(
      //     title: 'Error', message: 'Error getting products.', isError: true);
      debugPrint('## ERROR GETTING RECEIPTS: $e');
    } finally {
      debugPrint('## receipts list count: ${receipts.length}');
      receiptsLoaded(true);
    }
  }

  getProductReview() async {
    try {
      debugPrint('## getting product reviews');

      final snapShot = await firebase.collection(constants.review).get();
      // for (var element in snapShot.docs) {
      //   debugPrint(element.data().toString().replaceAll(', ', '\n'));
      // }

      productReviews(
          snapShot.docs.map((e) => ProductReview.fromSnapshot(e)).toList());
    } catch (e) {
      // uiUtils.showSnackBar(
      //     title: 'Error', message: 'Error getting products.', isError: true);
      debugPrint('## ERROR GETTING PRODUCT REVIEW: $e');
    } finally {
      debugPrint('## product review list count: ${productReviews.length}');
    }
  }

  filterReview() {}

  placeOrder() async {
    bool orderPlaced = false;
    try {
      Loaders().fullScreenLoader();
      activeReceipt = Receipt(
              code: userId!.value.toString(),
              cart: cartController.cart.toList(),
              placedIn: Timestamp.now(),
              totalPrice: cartController.total.value,
              shippingPrice: cartController.totalShipping.value,
              address: '',
              paymentMethod: '')
          .obs;

      await firebase
          .collection(constants.receipts)
          .doc(userId!.value.toString())
          .collection(constants.receipts)
          .add({
        'code': activeReceipt!.value.code,
        'cart': cartController.cart.toList().map((e) => e.toJson()),
        'placedIn': activeReceipt!.value.placedIn,
        'totalPrice': activeReceipt!.value.totalPrice,
        'shippingPrice': activeReceipt!.value.shippingPrice,
        'address': activeReceipt!.value.address,
        'paymentMethod': activeReceipt!.value.paymentMethod
      });
      orderPlaced = true;
    } catch (e) {
      UIUtils().showSnackBar(
          title: "Error!", message: "Error placing order!", isError: true);
      debugPrint('## ERROR PLACING ORDER: ${e.toString()}');
    } finally {
      Get.back();
      activeReceipt = null;
      if (orderPlaced) {
        UIUtils().showSnackBar(
            title: "Success!", message: "Order placed successfully!!");
        cartController.cart.clear();
        Get.offAll(() => const DashboardScreen());
      }
    }
  }

  submitProductReview({
    required Product product,
  }) async {
    bool reviewed = false;
    ProductController productController = Get.find<ProductController>();
    try {
      Loaders().fullScreenLoader();
      String? existingId;
      for (ProductReview review in productReviews) {
        if (review.productId.toLowerCase() == product.name.toLowerCase() &&
            review.customerId == userId!.value.toString()) {
          existingId = review.id;
          break;
        }
      }
      if (existingId != null) {
        await firebase
            .collection(constants.review)
            .doc(existingId.toString())
            .update({
          // 'userId': userId!.value.toString(),
          // 'product': product.name,
          'description': userReview.value.text.toString(),
          'rating': userRating.value + 1,
          // 'reviewId': UniqueKey().toString(),
          'reviewedDate': Timestamp.now()
        });
      } else {
        await firebase.collection(constants.review).add({
          'userId': userId!.value.toString(),
          'product': product.name,
          'description': userReview.value.text.toString(),
          'rating': userRating.value + 1,
          'reviewId': UniqueKey().toString(),
          'reviewedDate': Timestamp.now()
        });
      }

      reviewed = true;
    } catch (e) {
      UIUtils().showSnackBar(
          title: "Error!", message: "Error submitting review!", isError: true);
      debugPrint('## ERROR SUBMITTING REVIEW: ${e.toString()}');
    } finally {
      Get.back();
      activeReceipt = null;
      if (reviewed) {
        cartController.cart.clear();
        getProductReview();
        UIUtils().showSnackBar(
            title: "Success!", message: "Product reviewed successfully!!");
        productController.assignRatingAndReview();
        Get.offAll(() => const DashboardScreen());
      }
    }
  }
}
