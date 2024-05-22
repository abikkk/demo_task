import 'package:demo_task/model/cart_item_model.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../model/cart_model.dart';
import '../storage_helper.dart';
import '../view/loader_helpers.dart';
import '../view/ui_helpers.dart';

class CartController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  StorageHelper storageHelper = StorageHelper(); // storage helper

  RxList<CartItem> activeCart = <CartItem>[].obs;
  RxList<Cart> activeOrder = <Cart>[].obs;
  RxString activeOrderUserId = ''.obs;

  RxDouble activeCartTotal = 0.0.obs, activeTotalShipping = 20.0.obs;

  Constants constants = Constants();

  // @override
  // onInit() {
  //   getCartDetail();
  //   super.onInit();
  // }

  getCartDetail() async {
    try {
      activeOrderUserId(
          (await storageHelper.get(key: constants.user)).toString());

      // debugPrint('## getting order/cart list');

      final snapShot = await firebase
          .collection(constants.orders)
          .doc(activeOrderUserId.value)
          .collection(constants.orders)
          .get();
      // for (var element in snapShot.docs) {
      //   debugPrint(element.data().toString().replaceAll(', ', '\n'));
      // }
      if (snapShot.docs.isEmpty) {
        throw 'Could not get ${constants.orders} collection';
      }

      activeOrder(snapShot.docs.map((e) => Cart.fromSnapshot(e)).toList());
      activeOrder.removeWhere((element) => !element.isActive);
      if (activeOrder.isEmpty) {
        throw 'No cart instances found!';
      } else {
        activeCart(activeOrder.first.cart);
      }
    } catch (e) {
      // uiUtils.showSnackBar(
      //     title: 'Error', message: 'Error getting products.', isError: true);
      debugPrint('## ERROR GETTING ORDER LIST: $e');
      activeCart.clear();
      submitCart(isNew: true);
    } finally {
      debugPrint('## current active order/cart ID: ${activeOrderUserId.value}');
      debugPrint('## order list count: ${activeOrder.length}');
    }
  }

  getTotal() {
    activeCartTotal(0.0);
    activeTotalShipping(0);
    for (var cartItem in activeCart) {
      activeCartTotal(
          activeCartTotal.value + (cartItem.price * cartItem.quantity));
      activeTotalShipping(activeTotalShipping.value + 20);
    }
  }

  addToCart({
    required Product item,
    required int quantity,
    required int size,
    required int attributeIndex,
  }) {
    if (activeCart.isEmpty) {
      activeCart.add(CartItem(
        product: item.name,
        brand: item.brand,
        price: item.price,
        addedIn: Timestamp.now(),
        quantity: quantity,
        image: item.attribute[attributeIndex].image.first,
        size: size,
        color: item.attribute[attributeIndex].color,
      ));
    } else {
      bool isNew = true;
      for (var cartItem in activeCart) {
        if (cartItem.product == item.name &&
            size == cartItem.size &&
            item.attribute[attributeIndex].color == cartItem.color) {
          isNew = false;
          break;
        }
      }
      if (isNew) {
        activeCart.add(CartItem(
            product: item.name,
            brand: item.brand,
            price: item.price,
            addedIn: Timestamp.now(),
            quantity: quantity,
            image: item.attribute.first.image.first,
            size: size,
            color: item.attribute[attributeIndex].color));
      }
    }
  }

  removeFromCart({required CartItem item}) {
    if (activeCart.isNotEmpty) {
      activeCart.remove(item);
      getTotal();
    }
    submitCart();
  }

  updateCartItem({required int index, bool add = true}) async {
    if (add) {
      activeCart[index].quantity++;
    } else {
      activeCart[index].quantity--;
    }

    getTotal();
    activeCart.refresh();
  }

  Future<bool> submitCart({bool isNew = false, bool closeCart = false}) async {
    bool submitted = false;
    try {
      // Loaders().fullScreenLoader();

      if (closeCart) {
        await firebase
            .collection(constants.orders)
            .doc(activeOrderUserId.value)
            .collection(constants.orders)
            .doc(activeOrder.first.id)
            .update({'isActive': false});
      } else if (!isNew) {
        await firebase
            .collection(constants.orders)
            .doc(activeOrderUserId.value)
            .collection(constants.orders)
            .doc(activeOrder.first.id)
            .update({
          'cart': activeCart.toList().map((e) => e.toJson()),
          'isActive': true
        });
      } else {
        await firebase
            .collection(constants.orders)
            .doc(activeOrderUserId.value)
            .collection(constants.orders)
            .add({
          'cart': activeCart.toList().map((e) => e.toJson()),
          'placedIn': Timestamp.now(),
          'totalPrice': activeCartTotal.value,
          'shippingPrice': activeTotalShipping.value,
          'address': '',
          'paymentMethod': '',
          'id': activeOrderUserId.value,
          'isActive': true
        });
      }

      submitted = true;
    } catch (e) {
      // Get.back();
      UIUtils().showSnackBar(
          title: "Error!", message: "Error submitting cart!", isError: true);
      debugPrint('## ERROR SUBMITTING CART: ${e.toString()}');
    } finally {
      // Get.back();
      // if (submitted && activeCart.isNotEmpty) {
      //   UIUtils().showSnackBar(
      //       title: "Success!", message: "Added to cart successfully!");
      // }
      if (submitted && closeCart) {
        activeCart.clear();
        activeOrder.clear();
        onInit();
      }
    }
    return submitted;
  }
}
