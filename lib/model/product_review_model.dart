import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

ProductReview getProductReview(Map<String, dynamic> str) =>
    ProductReview.fromJson(str);

String productReviewJson(ProductReview data) => json.encode(data.toJson());

class ProductReview {
  ProductReview({
    required this.id,
    required this.code,
    required this.description,
    required this.customerId,
    required this.rating,
    required this.addedIn,
    required this.productId,
  });

  late final String id;
  late final String code;
  late final String description;
  late final String customerId;
  late final int rating;
  late final Timestamp addedIn;
  late final String productId;

  ProductReview.fromJson(Map<String, dynamic> json) {
    code = json['reviewId'];
    id = json['reviewId'];
    description = json['description'];
    customerId = json['userId'];
    rating = json['rating'];
    addedIn = json['reviewedDate'];
    productId = json['product'];
  }

  factory ProductReview.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return ProductReview(
        id: documentSnapshot.id.toString(),
        code: (docData['reviewId']).toString(),
        description: (docData['description']).toString(),
        customerId: (docData['userId']).toString(),
        rating: int.parse((docData['rating'] ?? 0).toString()),
        addedIn: (docData['reviewedDate'] ?? Timestamp.now()),
        productId: (docData['product']).toString());
  }

  Map<String, dynamic> toJson() {
    final productReview = <String, dynamic>{};
    productReview['reviewId'] = id;
    productReview['reviewId'] = code;
    productReview['description'] = description;
    productReview['userId'] = customerId;
    productReview['rating'] = rating;
    productReview['reviewedDate'] = addedIn;
    productReview['productId'] = productId;
    return productReview;
  }
}
