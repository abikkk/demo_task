import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import 'loader_helpers.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  ProductController productController = Get.find<ProductController>();
  CartController cartController = Get.find<CartController>();
  ReceiptController receiptController = Get.find<ReceiptController>();
  UIUtils uiUtils = UIUtils();
  Loaders loaders = Loaders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uiUtils.customAppBar(
          title: 'Order Summary', centerTitled: true, showAction: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              // payment method
              paymentSection(),

              // location detail
              locationSection(),

              // order detail
              const Text(
                'Order Detail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              // cart section
              cartSection(),

              // order detail
              const Text(
                'Payment Detail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              subTotalSection(), shippingSection(), totalOrderSection(),
            ],
          ),
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
                    'Grand Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '\$${(cartController.activeTotalShipping.value + cartController.activeCartTotal.value).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async => receiptController.placeOrder(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 50,
                width: 160,
                child: const Center(
                  child: Text(
                    'PAY',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  paymentSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Credit Card',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }

  locationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Kathmandu, Nepal',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }

  cartSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Obx(
        () => ListView.separated(
          shrinkWrap: true,
          itemCount: cartController.activeCart.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartController.activeCart[index].product.capitalize!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${cartController.activeCart[index].brand} . ${cartController.activeCart[index].color} . ${cartController.activeCart[index].size.toStringAsFixed(1)} . Qty ${cartController.activeCart[index].quantity}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      '\$${(cartController.activeCart[index].price * cartController.activeCart[index].quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 20,
            );
          },
        ),
      ),
    );
  }

  subTotalSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Obx(
        () => Row(
          children: [
            const Expanded(
              child: Text(
                'Sub Total',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              '\$${(cartController.activeCartTotal.value).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  shippingSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Obx(
        () => Row(
          children: [
            const Expanded(
              child: Text(
                'Shipping',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              '\$${(cartController.activeTotalShipping.value).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  totalOrderSection() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Obx(
        () => Row(
          children: [
            const Expanded(
              child: Text(
                'Total Order',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              '\$${(cartController.activeTotalShipping.value + cartController.activeCartTotal.value).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
