import 'dart:convert';
Brand getBrand(Map<String, dynamic> str) => Brand.fromJson(str);
String brandJson(Brand data) =>json.encode(data.toJson());

class Brand {
  Brand({
    required this.code,
    required this.name,
    required this.logo,
  });
  late final String code;
  late final String name;
  late final String logo;

  Brand.fromJson(Map<String, dynamic> json){
    code = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final brand = <String, dynamic>{};
    brand['id'] = code;
    brand['name'] = name;
    brand['logo'] = logo;
    return brand;
  }
}