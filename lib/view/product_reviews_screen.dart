import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../controller/product_controller.dart';
import '../controller/receipt_controller.dart';
import 'ui_helpers.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreeState();
}

class _ProductReviewsScreeState extends State<ProductReviewsScreen> {
  ProductController productController = Get.find<ProductController>();
  ReceiptController receiptController = Get.find<ReceiptController>();
  UIUtils uiUtils = UIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiptController.reviewIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: uiUtils.customAppBar(
            centerTitled: true,
            title:
                'Reviews (${productController.currentProduct!.value.reviews})',
            showAction: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Obx(
                    () => ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      // itemCount: 6,
                      children: [
                        GestureDetector(
                            onTap: () => receiptController.reviewIndex(0),
                            child: uiUtils.tipBubbles(
                                title: 'All',
                                active:
                                    receiptController.reviewIndex.value == 0)),
                        GestureDetector(
                          onTap: () => receiptController.reviewIndex(5),
                          child: uiUtils.tipBubbles(
                              title: '5 stars',
                              active: receiptController.reviewIndex.value == 5),
                        ),
                        GestureDetector(
                          onTap: () => receiptController.reviewIndex(4),
                          child: uiUtils.tipBubbles(
                              title: '4 stars',
                              active: receiptController.reviewIndex.value == 4),
                        ),
                        GestureDetector(
                          onTap: () => receiptController.reviewIndex(3),
                          child: uiUtils.tipBubbles(
                              title: '3 stars',
                              active: receiptController.reviewIndex.value == 3),
                        ),
                        GestureDetector(
                          onTap: () => receiptController.reviewIndex(2),
                          child: uiUtils.tipBubbles(
                              title: '2 stars',
                              active: receiptController.reviewIndex.value == 2),
                        ),
                        GestureDetector(
                          onTap: () => receiptController.reviewIndex(1),
                          child: uiUtils.tipBubbles(
                              title: '1 star',
                              active: receiptController.reviewIndex.value == 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => uiUtils.reviewItem(
                      showAll: true,
                      stars: receiptController.reviewIndex.value),
                ),
              ],
            ),
          ),
        ));
  }
}
