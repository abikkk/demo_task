import 'dart:convert';

ProductReview getProductReview(Map<String, dynamic> str) =>
    ProductReview.fromJson(str);

String productReviewJson(ProductReview data) => json.encode(data.toJson());

class ProductReview {
  ProductReview({
    required this.code,
    required this.description,
    required this.customerName,
    required this.customerId,
    required this.rating,
    required this.addedIn,
    required this.images,
    required this.productId,
  });

  late final String code;
  late final String description;
  late final String customerName;
  late final String customerId;
  late final int rating;
  late final DateTime addedIn;
  late final List<String> images;
  late final String productId;

  ProductReview.fromJson(Map<String, dynamic> json) {
    code = json['id'];
    description = json['description'];
    customerName = json['id'];
    customerId = json['description'];
    rating = json['id'];
    addedIn = json['description'];
    images = json['description'];
    productId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final productReview = <String, dynamic>{};
    productReview['id'] = code;
    productReview['description'] = description;
    productReview['id'] = customerName;
    productReview['description'] = customerId;
    productReview['id'] = rating;
    productReview['description'] = addedIn;
    productReview['description'] = images;
    productReview['id'] = productId;
    return productReview;
  }
}
