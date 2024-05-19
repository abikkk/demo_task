import 'package:demo_task/controller/cart_controller.dart';
import 'package:demo_task/controller/product_controller.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductController productController = Get.find<ProductController>();
  CartController cartController = Get.find<CartController>();
  UIUtils uiUtils = UIUtils();

  int picIndex = 0, sizeIndex = 0, colorIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // resetting values
    productController.quantityController(TextEditingController(text: '1'));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: uiUtils.customAppBar(title: ''),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product image
                Center(
                  child: SizedBox(
                    height: 0.4.sh,
                    width: 0.8.sw,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: productController
                              .currentProduct!
                              .value
                              .colors[productController.tempProductColor.value]!
                              .length,
                          pageSnapping: true,
                          onPageChanged: (page) {
                            setState(() {
                              picIndex = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: uiUtils.cachedImage(
                                    url: productController
                                            .currentProduct!.value.colors[
                                        productController
                                            .tempProductColor.value]![index]),
                              ),
                            );
                          },
                        ),
                        // pagination for images and colors
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 30,
                              child: Row(
                                children: [
                                  // image pagination
                                  Expanded(
                                      child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productController
                                        .currentProduct!
                                        .value
                                        .colors[productController
                                            .tempProductColor.value]!
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Icon(
                                          Icons.circle,
                                          color: (picIndex == index)
                                              ? Colors.black
                                              : Colors.grey,
                                          size: 10,
                                        ),
                                      );
                                    },
                                  )),

                                  // colors pagination
                                  Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productController
                                              .currentProduct!
                                              .value
                                              .colors
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List colorKeys = productController
                                                .currentProduct!
                                                .value
                                                .colors
                                                .keys
                                                .toList();

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  colorIndex = index;
                                                });
                                                productController
                                                    .tempProductColor(
                                                        colorKeys[index]);
                                                picIndex = 0;
                                              },
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: (colorIndex ==
                                                                  index)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .transparent)),
                                                  // padding: EdgeInsets.all(4),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: (colorKeys[
                                                                    index] ==
                                                                'black')
                                                            ? Colors.black
                                                            : (colorKeys[
                                                                        index] ==
                                                                    'red')
                                                                ? Colors.red
                                                                : (colorKeys[
                                                                            index] ==
                                                                        'brown')
                                                                    ? Colors
                                                                        .brown
                                                                    : (colorKeys[index] ==
                                                                            'blue')
                                                                        ? Colors
                                                                            .blue
                                                                        : (colorKeys[index] ==
                                                                                'navy')
                                                                            ? Colors.blue.shade900
                                                                            : (colorKeys[index] == 'mustard')
                                                                                ? Colors.yellow.shade800
                                                                                : (colorKeys[index] == 'yellow')
                                                                                    ? Colors.yellow
                                                                                    : Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // product name
                Text(
                  productController.currentProduct!.value.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // product rating and review
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount:
                            productController.currentProduct!.value.rating,
                        itemBuilder: (BuildContext context, int index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${productController.currentProduct!.value.rating.toDouble()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      '(109 Reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // size row
                const Text(
                  'Size',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: productController
                              .currentProduct!.value.size.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                productController.tempProductSize(
                                    productController
                                        .currentProduct!.value.size[index]);
                                setState(() {
                                  sizeIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (sizeIndex == index)
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    productController
                                        .currentProduct!.value.size[index]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: (sizeIndex == index)
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // product description
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                Text(
                  productController.currentProduct!.value.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                // product review
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Reviews (109)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                      'Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$${productController.currentProduct!.value.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  uiUtils.addToCart(
                      product: productController.currentProduct!.value,
                      size: productController.tempProductSize.value,
                      color: productController.tempProductColor.value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 160,
                  child: const Center(
                    child: Text(
                      'ADD TO CART',
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
