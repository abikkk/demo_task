import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/view/loader_helpers.dart';
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
  Loaders loaders = Loaders();

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
        appBar: uiUtils.customAppBar(
            title: 'Receipts', showAction: false, centerTitled: true),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  (!receiptController.receiptsLoaded.value)
                      ? ListView.builder(
                          itemCount: 8,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              loaders.receiptLoader(),
                        )
                      : (receiptController.receipts.isEmpty)
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
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        height: 30,
                                        indent: 10,
                                        endIndent: 10,
                                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
