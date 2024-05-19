import 'dart:convert';

import 'package:demo_task/model/product_model.dart';

CartItem getCartItem(Map<String, dynamic> str) => CartItem.fromJson(str);

String cartItemJson(CartItem data) => json.encode(data.toJson());

class CartItem {
  CartItem({
    // required this.code,
    required this.product,
    required this.addedIn,
    required this.quantity,
    // required this.price,
    required this.image,
    required this.color,
    required this.size,
  });

  // late final int code;
  late final Product product;
  late final DateTime addedIn;
  late int quantity;
  // late double price;
  late final double size;
  late final String image;
  late final String color;

  CartItem.fromJson(Map<String, dynamic> json) {
    // code = json['Code'];
    product = json['Message'];
    addedIn = json['Data'];
    quantity = json['quantity'];
    // price = json['price'];
    image = json['image'];
    size = json['size'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final cartItem = <String, dynamic>{};
    // cartItem['Code'] = code;
    cartItem['Message'] = product;
    cartItem['Data'] = addedIn;
    cartItem['quantity'] = quantity;
    // cartItem['price'] = price;
    cartItem['image'] = image;
    cartItem['size'] = size;
    cartItem['color'] = color;
    return cartItem;
  }
}
