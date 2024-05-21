import 'dart:convert';
import 'package:demo_task/model/cart_item_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

Receipt getReceipt(Map<String, dynamic> str) => Receipt.fromJson(str);

String receiptJson(Receipt data) => json.encode(data.toJson());

class Receipt {
  Receipt({
    required this.code,
    required this.cart,
    required this.placedIn,
    required this.totalPrice,
    required this.shippingPrice,
    required this.address,
    required this.paymentMethod,
  });

  late final String code;
  late final List<CartItem> cart;
  late final Timestamp placedIn;
  late final double totalPrice;
  late final double shippingPrice;
  late final String address;
  late final String paymentMethod;

  Receipt.fromJson(Map<String, dynamic> json) {
    code = (json['code']).toString();
    cart = json['cart'];
    placedIn = json['placedIn'];
    totalPrice = json['totalPrice'];
    shippingPrice = json['shippingPrice'];
    address = json['address'];
    paymentMethod = json['paymentMethod'];
  }

  factory Receipt.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return Receipt(
      code: (docData['code']).toString(),
      cart: (docData['cart'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      placedIn: docData['placedIn'] ?? Timestamp.now(),
      totalPrice: docData['totalPrice'] ?? 0.0,
      shippingPrice: docData['shippingPrice'] ?? 0.0,
      address: (docData['address']).toString(),
      paymentMethod: (docData['paymentMethod']).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final cartItem = <String, dynamic>{};
    cartItem['code'] = code;
    cartItem['cart'] = cart;
    cartItem['placedIn'] = placedIn;
    cartItem['totalPrice'] = totalPrice;
    cartItem['shippingPrice'] = shippingPrice;
    cartItem['address'] = address;
    cartItem['paymentMethod'] = paymentMethod;
    return cartItem;
  }
}
