import 'package:demo_task/controller/cart_controller.dart';
import 'package:demo_task/controller/product_controller.dart';
import 'package:demo_task/model/brand_model.dart';
import 'package:demo_task/view/filter_screen.dart';
import 'package:demo_task/view/product_screen.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProductController productController =
      Get.put(ProductController(), permanent: true);
  CartController cartController = Get.put(CartController(), permanent: true);
  UIUtils uiUtils = UIUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () => Get.to(() => const FilterScreen()),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
            height: 50,
            width: 130,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_list_outlined,
                  color: Colors.white,
                ),
                Text(
                  'FILTER',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        appBar: uiUtils.customAppBar(title: 'Discover'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    uiUtils.brandBubbles(
                        brand: Brand(code: '1', name: 'Adidas', logo: 'logo'),
                        active: true),
                    uiUtils.brandBubbles(
                        brand: Brand(code: '1', name: 'Nike', logo: 'logo')),
                    uiUtils.brandBubbles(
                        brand: Brand(
                            code: '1', name: 'New Balance', logo: 'logo')),
                  ],
                ),
                GridView.builder(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  itemCount: productController.products.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        productController.setCurrentProduct(
                            product: productController.products[index]);

                        Get.to(() => const ProductScreen());
                      },
                      child: uiUtils.product(
                          product: productController.products[index]),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
