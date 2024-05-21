import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

Brand getBrand(Map<String, dynamic> str) => Brand.fromJson(str);

String brandJson(Brand data) => json.encode(data.toJson());

class Brand {
  Brand({
    required this.code,
    required this.name,
    required this.logo,
  });

  late final String code;
  late final String name;
  late final String logo;

  Brand.fromJson(Map<String, dynamic> json) {
    code = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  factory Brand.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    // code = json['id'];
    return Brand(
        code: documentSnapshot.id,
        name: (docData['name']).toString(),
        logo: (docData['logo']).toString());
  }

  Map<String, dynamic> toJson() {
    final brand = <String, dynamic>{};
    // brand['id'] = code;
    brand['name'] = name;
    brand['logo'] = logo;
    return brand;
  }
}
