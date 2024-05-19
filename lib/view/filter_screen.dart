import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  ProductController productController = Get.find<ProductController>();
  UIUtils uiUtils = UIUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: uiUtils.customAppBar(
            title: 'Filter', centerTitled: true, showAction: false),
        body: const Placeholder());
  }
}
