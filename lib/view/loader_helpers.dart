import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loaders {
  Widget dashboardProductLoader() {
    return const SizedBox.shrink();
  }

  Future fullScreenLoader() {
    return Get.dialog(
        barrierDismissible: false,
        const SizedBox(
          // color: Colors.white,
          height: 60,
          width: 60,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
