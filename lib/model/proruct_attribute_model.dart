import 'dart:convert';

ProductAttribute getProductAttribute(Map<String, dynamic> str) =>
    ProductAttribute.fromJson(str);

String productAttributeJson(ProductAttribute data) =>
    json.encode(data.toJson());

class ProductAttribute {
  ProductAttribute({
    required this.color,
    required this.size,
    required this.image,
  });

  late final String color;
  late final List<int> size;
  late final List<String> image;

  ProductAttribute.fromJson(Map<String, dynamic> json) {
    color = (json['color'] ?? 'black').toString();
    size = List<int>.from(json['size']);
    image = List<String>.from(json['image']);
  }

  Map<String, dynamic> toJson() {
    final brand = <String, dynamic>{};
    brand['color'] = color;
    brand['size'] = size;
    brand['image'] = image;
    return brand;
  }
}
