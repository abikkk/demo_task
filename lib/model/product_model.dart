import 'dart:convert';
Product getProduct(Map<String, dynamic> str) => Product.fromJson(str);
String getProductJson(Product data) =>json.encode(data.toJson());

class Product {
  Product({
    required this.code,
    required this.message,
    required this.data,
  });
  late final int code;
  late final String message;
  late final bool data;

  Product.fromJson(Map<String, dynamic> json){
    code = json['Code'];
    message = json['Message'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final checkEmailData = <String, dynamic>{};
    checkEmailData['Code'] = code;
    checkEmailData['Message'] = message;
    checkEmailData['Data'] = data;
    return checkEmailData;
  }

}