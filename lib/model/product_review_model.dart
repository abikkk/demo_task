import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

ProductReview getProductReview(Map<String, dynamic> str) =>
    ProductReview.fromJson(str);

String productReviewJson(ProductReview data) => json.encode(data.toJson());

class ProductReview {
  ProductReview({
    required this.code,
    required this.description,
    required this.customerId,
    required this.rating,
    required this.addedIn,
    required this.productId,
  });

  late final String code;
  late final String description;
  late final String customerId;
  late final int rating;
  late final Timestamp addedIn;
  late final String productId;

  ProductReview.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    customerId = json['customerId'];
    rating = json['rating'];
    addedIn = json['addedIn'];
    productId = json['productId'];
  }

  factory ProductReview.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return ProductReview(
        code: (docData['code']).toString(),
        description: (docData['description']).toString(),
        customerId: (docData['customerId']).toString(),
        rating: int.parse(docData['rating'] ?? 0),
        addedIn: (docData['addedIn'] ?? Timestamp.now()),
        productId: (docData['productId']).toString());
  }

  Map<String, dynamic> toJson() {
    final productReview = <String, dynamic>{};
    productReview['code'] = code;
    productReview['description'] = description;
    productReview['customerId'] = customerId;
    productReview['rating'] = rating;
    productReview['addedIn'] = addedIn;
    productReview['productId'] = productId;
    return productReview;
  }
}
