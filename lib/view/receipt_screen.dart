import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  ReceiptController receiptController = Get.find<ReceiptController>();
  UIUtils uiUtils = UIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiptController.getReceipts();
    receiptController.getProductReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: uiUtils.customAppBar(title: 'Receipts', showAction: false),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  (receiptController.receipts.isEmpty)
                      ? const Center(
                          child: Text('Empty cart!'),
                        )
                      // receipt list
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: receiptController.receipts.length,
                          itemBuilder: (BuildContext context, int index) =>
                              uiUtils.receiptItem(index: index),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 10,
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
