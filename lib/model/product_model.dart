import 'dart:convert';

import 'package:demo_task/model/product_review_model.dart';

import 'brand_model.dart';

Product getProduct(Map<String, dynamic> str) => Product.fromJson(str);

String productJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.code,
    required this.description,
    required this.name,
    required this.price,
    required this.rating,
    required this.size,
    required this.colors,
    required this.brand,
    required this.reviews,
    required this.inStock,
  });

  late final String code;
  late final String description;
  late final String name;
  late final double price;
  late final int rating;
  late final List<double> size;
  late final Map<String, List<String>> colors;
  late final Brand brand;
  late final List<ProductReview>? reviews;
  late final bool inStock;

  Product.fromJson(Map<String, dynamic> json) {
    code = json['id'];
    description = json['description'];
    name = json['name'];
    price = json['price'];
    rating = json['rating'];
    size = json['size'];
    colors = json['colors'];
    brand = json['brand'];
    reviews = json['reviews'];
    inStock = json['inStock'];
  }

  Map<String, dynamic> toJson() {
    final product = <String, dynamic>{};
    product['id'] = code;
    product['description'] = description;
    product['name'] = name;
    product['price'] = price;
    product['rating'] = rating;
    product['size'] = size;
    product['colors'] = colors;
    product['brand'] = brand;
    product['reviews'] = reviews;
    product['inStock'] = inStock;
    return product;
  }
}
