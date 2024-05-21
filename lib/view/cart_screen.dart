import 'package:demo_task/view/checkout_screen.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ProductController productController = Get.find<ProductController>();
  CartController cartController = Get.find<CartController>();
  UIUtils uiUtils = UIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartController.getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: uiUtils.customAppBar(
            title: 'Cart',
            centerTitled: true,
            showAction: true,
            showCart: false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (cartController.cart.isEmpty)
                  ? const Center(
                      child: Text('Empty cart!'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: cartController.cart.length,
                      itemBuilder: (BuildContext context, int index) {
                        return uiUtils.cartItem(index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$${cartController.total.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (cartController.cart.isNotEmpty) {
                    cartController.getTotal();
                    Get.to(() => const CheckOutScreen());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (cartController.cart.isNotEmpty)
                        ? Colors.black
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 160,
                  child: Center(
                    child: Text(
                      'CHECK OUT',
                      style: TextStyle(
                          fontSize: 14,
                          color: (cartController.cart.isNotEmpty)
                              ? Colors.white
                              : Colors.black45),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
