import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_task/model/cart_item_model.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:demo_task/view/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import '../model/brand_model.dart';

class UIUtils {
  ProductController productController = Get.find<ProductController>();
  CartController cartController = Get.find<CartController>();

  // app bar
  AppBar customAppBar(
      {required String title,
      bool centerTitled = false,
      bool showAction = true}) {
    return AppBar(
      centerTitle: centerTitled,
      title: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
      actions: (showAction)
          ? [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Get.to(() => const CartScreen());
                },
              )
            ]
          : [],
    );
  }

  // brand bubble for dashboard
  Widget brandBubbles({required Brand brand, bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        brand.name,
        style: TextStyle(
            color: (active) ? Colors.black : Colors.black45, fontSize: 18),
      ),
    );
  }

  // cached image
  CachedNetworkImage cachedImage(
      {required String url,
      double height = 45,
      double width = 45,
      bool contain = true}) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          image: DecorationImage(
            image: imageProvider,
            fit: contain ? BoxFit.contain : BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.error),
      ),
    );
  }

  // product widget for dashboard
  Widget product({required Product product}) {
    return Container(
      width: 0.5.sw,
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: cachedImage(
                      url: product.colors['black']!.first,
                      contain: false,
                      height: 100))),

          // product name
          Text(
            product.name.capitalize!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),

          // product rating and review
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${product.rating.toDouble()}',
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

          // product price
          Text(
            '\$${product.price.toDouble()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget cartItem({required int index}) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            onPressed: (val) =>
                cartController.removeFromCart(item: cartController.cart[index]),
            backgroundColor: Colors.red.shade300,
            foregroundColor: Colors.white,
            icon: Icons.delete_sharp,
            label: 'Remove',
          ),
        ],
      ),
      child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: cachedImage(
                          url: cartController.cart[index].image,
                          contain: false)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            cartController.cart[index].product.name
                                .toString()
                                .capitalize!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${cartController.cart[index].product.brand.name.toString().capitalize} . ${cartController.cart[index].color.capitalize} . ${cartController.cart[index].size}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${cartController.cart[index].product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => (cartController.cart[index].quantity < 2)
                              ? {}
                              : cartController.updateCartItem(
                                  index: index, add: false),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color:
                                        (cartController.cart[index].quantity <
                                                2)
                                            ? Colors.grey
                                            : Colors.black)),
                            padding: const EdgeInsets.all(1),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color: (cartController.cart[index].quantity < 2)
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            cartController.cart[index].quantity.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              cartController.updateCartItem(index: index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  // add to cart for product page
  Future addToCart(
      {required Product product, required String color, required double size}) {
    // double totalPrice = product.price;
    productController.tempTotalPrice(
        (int.parse(productController.quantityController.value.text) *
            product.price));

    return Get.bottomSheet(
      backgroundColor: Colors.white,
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 1.sw,
          height: 0.5.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    height: 5,
                    width: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close_rounded))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // quantity row
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller:
                                productController.quantityController.value,
                            decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: InputBorder.none),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (int.parse(productController
                                    .quantityController.value.text) >
                                1) {
                              productController.quantityController.value.text =
                                  (int.parse(productController
                                              .quantityController.value.text) -
                                          1)
                                      .toString();

                              productController.tempTotalPrice((int.parse(
                                          productController
                                              .quantityController.value.text) *
                                      product.price)
                                  .toDouble());
                            }
                            // debugPrint(totalPrice.toStringAsFixed(2));
                          },
                          child: const CircleAvatar(
                            child: Icon(
                              Icons.remove,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            productController.quantityController.value.text =
                                (int.parse(productController
                                            .quantityController.value.text) +
                                        1)
                                    .toString();

                            productController.tempTotalPrice((int.parse(
                                        productController
                                            .quantityController.value.text) *
                                    product.price)
                                .toDouble());
                          },
                          child: const CircleAvatar(
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
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
                          Obx(
                            () => Text(
                              '\$${productController.tempTotalPrice.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        if (int.parse(productController
                                .quantityController.value.text) >
                            0) {
                          cartController.addToCart(
                              item: product,
                              quantity: int.parse(
                                productController.quantityController.value.text,
                              ),
                              size: size,
                              color: color);
                          addedToCart(
                              quantity: int.parse(productController
                                  .quantityController.value.text));
                        }
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
            ],
          )),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  // success for cart addition
  Future addedToCart({required int quantity}) {
    return Get.bottomSheet(
      backgroundColor: Colors.white,
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 1.sw,
          height: 0.4.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    height: 5,
                    width: 30,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5)),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                    'Added to cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                ],
              ),
              Center(
                  child: Text(
                '$quantity item(s) added',
                style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.w700,
                    color: Colors.grey),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const SizedBox(
                        height: 50,
                        width: 160,
                        child: Center(
                          child: Text(
                            'BACK TO EXPLORE',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const CartScreen());
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
                            'TO CART',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }
}
