import 'package:demo_task/model/cart_item_model.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants.dart';

class CartController extends GetxController {
  final firebase = FirebaseFirestore.instance;

  RxList<CartItem> cart = <CartItem>[].obs;
  RxDouble total = 0.0.obs, totalShipping = 20.0.obs;

  Constants constants = Constants();

  getTotal() {
    total(0.0);
    totalShipping(0);
    for (var cartItem in cart) {
      total(total.value + (cartItem.price * cartItem.quantity));
      totalShipping(totalShipping.value + 20);
    }
  }

  addToCart({
    required Product item,
    required int quantity,
    required int size,
    required int attributeIndex,
  }) {
    if (cart.isEmpty) {
      cart.add(CartItem(
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
      for (var cartItem in cart) {
        if (cartItem.product == item.name &&
            size == cartItem.size &&
            item.attribute[attributeIndex].color == cartItem.color) {
          isNew = false;
          break;
        }
      }
      if (isNew) {
        cart.add(CartItem(
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
    if (cart.isNotEmpty) {
      cart.remove(item);
      getTotal();
    }
  }

  updateCartItem({required int index, bool add = true}) async {
    if (add) {
      cart[index].quantity++;
    } else {
      cart[index].quantity--;
    }

    getTotal();
    cart.refresh();
  }
}
