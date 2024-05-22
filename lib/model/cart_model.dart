import 'dart:convert';
import 'package:demo_task/model/cart_item_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

Cart getReceipt(Map<String, dynamic> str) => Cart.fromJson(str);

String receiptJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    // required this.code,
    required this.id,
    required this.cart,
    required this.placedIn,
    required this.totalPrice,
    required this.shippingPrice,
    required this.address,
    required this.paymentMethod,
    required this.isActive,
  });

  // late final String code;
  late final String id;
  late final List<CartItem> cart;
  late final Timestamp placedIn;
  late final double totalPrice;
  late final double shippingPrice;
  late final String address;
  late final String paymentMethod;
  late final bool isActive;

  Cart.fromJson(Map<String, dynamic> json) {
    // code = (json['code']).toString();
    id = (json['code']).toString();
    cart = json['cart'];
    placedIn = json['placedIn'];
    totalPrice = json['totalPrice'];
    shippingPrice = json['shippingPrice'];
    address = json['address'];
    paymentMethod = json['paymentMethod'];
    isActive = json['isActive'];
  }

  factory Cart.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return Cart(
      id: (documentSnapshot.id).toString(),
      // code: (docData['code']).toString(),
      cart: (docData['cart'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      placedIn: docData['placedIn'] ?? Timestamp.now(),
      totalPrice: docData['totalPrice'] ?? 0.0,
      shippingPrice: docData['shippingPrice'] ?? 0.0,
      address: (docData['address']).toString(),
      paymentMethod: (docData['paymentMethod']).toString(),
      isActive: (docData['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    final cartItem = <String, dynamic>{};
    cartItem['code'] = id;
    // cartItem['code'] = code;
    cartItem['cart'] = cart;
    cartItem['placedIn'] = placedIn;
    cartItem['totalPrice'] = totalPrice;
    cartItem['shippingPrice'] = shippingPrice;
    cartItem['address'] = address;
    cartItem['paymentMethod'] = paymentMethod;
    cartItem['isActive'] = isActive;
    return cartItem;
  }
}
