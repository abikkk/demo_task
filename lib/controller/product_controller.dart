import 'package:demo_task/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/brand_model.dart';

class ProductController extends GetxController {
  Rx<TextEditingController> quantityController =
      TextEditingController(text: '1').obs;
  RxDouble tempTotalPrice = 0.0.obs, tempProductSize = 0.0.obs;
  RxString tempProductColor = ''.obs;

  Rx<Product>? currentProduct;
  RxList<Product> products = [
    Product(
        code: 'code',
        description: 'description',
        inStock: true,
        name: 'nike shoe',
        price: 1200,
        rating: 4,
        size: [41, 42, 43],
        colors: {
          'black': [
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436227060_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/340576/3405765950_zm.jpg'
          ],
          'white': [
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436227060_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/340576/3405765950_zm.jpg'
          ],
          'grey': [
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436227060_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/340576/3405765950_zm.jpg'
          ]
        },
        brand: Brand(code: '1', name: 'Nike', logo: 'logo'),
        reviews: []),
    Product(
        code: 'code',
        description: 'description',
        inStock: true,
        name: 'adidas shoe',
        price: 1200,
        rating: 4,
        size: [41, 42, 43],
        colors: {
          'black': [
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/342389/3423895450_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/340140/3401407070_zm.jpg'
          ],
          'white': [
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            // 'https://d2ob0iztsaxy5v.cloudfront.net/product/342389/3423895450_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/340140/3401407070_zm.jpg'
          ],
          'grey': [
            'https://d2ob0iztsaxy5v.cloudfront.net/product/343622/3436221060_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/342389/3423895450_zm.jpg',
            'https://d2ob0iztsaxy5v.cloudfront.net/product/340140/3401407070_zm.jpg'
          ]
        },
        brand: Brand(code: '2', name: 'Adidas', logo: 'logo'),
        reviews: []),
  ].obs;

  setCurrentProduct({required Product product}) {
    currentProduct = product.obs;
    tempProductColor(product.colors.keys.first);
    tempProductSize(product.size.first.toDouble());

    debugPrint(
        '>> set size: ${tempProductSize.value} || set color: ${tempProductColor.value}');
  }
}
