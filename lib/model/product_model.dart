import 'dart:convert';

import 'package:demo_task/model/product_review_model.dart';
import 'package:demo_task/model/proruct_attribute_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:get/get.dart';

import 'brand_model.dart';

Product getProduct(Map<String, dynamic> str) => Product.fromJson(str);

String productJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.attribute,
    required this.brand,
    required this.gender,
    required this.added,
  });

  late final String id;
  late final String description;
  late final String name;
  late final double price;
  late final List<ProductAttribute> attribute;
  late final String brand;
  late final String gender;
  late final Timestamp added;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    name = json['name'];
    price = json['price'];
    attribute = List<ProductAttribute>.from(json['attribute']);
    brand = json['brand'];
    gender = json['gender'];
    added = json['added'];
  }

  factory Product.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final docData = doc.data()!;

    return Product(
        id: doc.id,
        description: (docData['description'] ?? '').toString(),
        name: (docData['name'] ?? '').toString(),
        price: double.parse((docData['price'] ?? 0.0).toString()),
        attribute: (docData['attribute'] as List<dynamic>)
            .map((e) => ProductAttribute.fromJson(e))
            .toList(),
        brand: (docData['brand'] ?? '').toString(),
        added: (docData['added'] ?? Timestamp.now()),
        gender: (docData['gender'] ?? '').toString());
  }

  Map<String, dynamic> toJson() {
    final product = <String, dynamic>{};
    product['description'] = description;
    product['name'] = name;
    product['price'] = price;
    product['attribute'] = attribute.map((e) => e.toJson()).toList();
    product['brand'] = brand;
    product['gender'] = gender;
    product['added'] = added;

    return product;
  }
}
