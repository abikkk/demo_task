import 'package:demo_task/model/cart_item_model.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<CartItem> cart = <CartItem>[].obs;
  RxDouble total = 0.0.obs;

  getTotal() {
    total(0.0);
    for (var cartItem in cart) {
      total(total.value + (cartItem.product.price * cartItem.quantity));
    }
  }

  addToCart(
      {required Product item,
      required int quantity,
      required double size,
      required String color}) {
    if (cart.isEmpty) {
      cart.add(CartItem(
          product: item,
          addedIn: DateTime.now(),
          quantity: quantity,
          // price: item.price,
          image: item.colors.values.first.first,
          size: size,
          color: color));
    } else {
      bool isNew = true;
      for (var cartItem in cart) {
        if (cartItem.product == item &&
            size == cartItem.size &&
            color == cartItem.color) {
          isNew = false;
          break;
        }
      }
      if (isNew) {
        cart.add(CartItem(
            product: item,
            addedIn: DateTime.now(),
            quantity: quantity,
            // price: item.price,
            image: item.colors.values.first.first,
            size: size,
            color: color));
      }
    }
  }

  removeFromCart({required CartItem item}) {
    if (cart.isNotEmpty) {
      cart.remove(item);
    }
  }

  updateCartItem({required int index, bool add = true}) {
    if (add) {
      cart[index].quantity++;
    } else {
      cart[index].quantity--;
    }

    getTotal();
    cart.refresh();
  }
}
