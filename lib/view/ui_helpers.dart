import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_task/constants.dart';
import 'package:demo_task/controller/filter_controller.dart';
import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/model/product_model.dart';
import 'package:demo_task/model/product_review_model.dart';
import 'package:demo_task/view/cart_screen.dart';
import 'package:demo_task/view/dashboard_screen.dart';
import 'package:demo_task/view/loader_helpers.dart';
import 'package:demo_task/view/product_screen.dart';
import 'package:demo_task/view/receipt_screen.dart';
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
import '../storage_helper.dart';

class UIUtils {
  ProductController productController = Get.find<ProductController>();
  CartController cartController = Get.find<CartController>();
  FilterController filterController = Get.find<FilterController>();
  ReceiptController receiptController = Get.find<ReceiptController>();
  Loaders loaders = Loaders();
  StorageHelper storageHelper = StorageHelper(); // storage helper

  // app bar
  AppBar customAppBar({
    required String title,
    bool centerTitled = false,
    bool showAction = true,
    bool showCart = true,
  }) {
    return AppBar(
      centerTitle: centerTitled,
      title: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
      actions: (showAction)
          ? [
              (showCart)
                  ? IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        Get.to(() => const CartScreen());
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.receipt_long_sharp),
                      onPressed: () {
                        Get.to(() => const ReceiptScreen());
                      },
                    )
            ]
          : [],
    );
  }

  Future selectUser() async {
    String userId = (await storageHelper.get(key: Constants().user)).toString();
    return Get.bottomSheet(
        backgroundColor: Colors.white,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          height: 0.3.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      height: 5,
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Select user for app usage:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Constants().userId.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      receiptController.createNewUser(user: index + 1);
                      Get.back();
                      showSnackBar(
                          title: 'User changed!',
                          message: 'Current user: $userId');
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          Constants().userId[index].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        (Constants().userId[index] == userId)
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  // brand bubble for dashboard
  Widget tipBubbles(
      {required String title, bool active = false, bool filterScreen = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: (filterScreen) ? 0 : 5, horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
            color: (active) ? Colors.black : Colors.black45, fontSize: 18),
      ),
    );
  }

  // cached image
  CachedNetworkImage cachedImage(
      {required String url,
      double? height,
      double? width,
      bool contain = true}) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: contain ? BoxFit.contain : BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          loaders.imageLoader(height, width),
      // CircularProgressIndicator(value: downloadProgress.progress),
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
    Brand productBrand = filterController.brands.firstWhere(
        (element) => element.name.toLowerCase() == product.brand.toLowerCase());
    return Container(
      width: 0.5.sw,
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // product and brand image
          Expanded(
              child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: cachedImage(
                    url: product.attribute.first.image.first,
                    contain: false,
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: cachedImage(
                    url: productBrand.logo,
                    contain: true,
                    height: 33,
                    width: 33),
              ),
            ],
          )),

          // product name
          Text(
            product.name.capitalize!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          // product rating and review
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 60,
              //   child: ListView.separated(
              //     itemCount: product.rating.toInt(),
              //     scrollDirection: Axis.horizontal,
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int index) => const Icon(
              //       Icons.star,
              //       color: Colors.yellow,
              //       size: 15,
              //     ),
              //     separatorBuilder: (BuildContext context, int index) =>
              //         const SizedBox(
              //       width: 5,
              //     ),
              //   ),
              // ),
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${product.rating}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${product.reviews} Review(s)',
                style: const TextStyle(
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

  // cart item
  Widget cartItem({required int index}) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            onPressed: (val) => cartController.removeFromCart(
                item: cartController.activeCart[index]),
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
                          url: cartController.activeCart[index].image,
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
                            cartController.activeCart[index].product
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
                          '${cartController.activeCart[index].brand.toString().capitalize} . ${cartController.activeCart[index].color.capitalize} . ${cartController.activeCart[index].size}',
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
                            '\$${cartController.activeCart[index].price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              (cartController.activeCart[index].quantity < 2)
                                  ? {}
                                  : cartController.updateCartItem(
                                      index: index, add: false),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: (cartController
                                                .activeCart[index].quantity <
                                            2)
                                        ? Colors.grey
                                        : Colors.black)),
                            padding: const EdgeInsets.all(1),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color:
                                  (cartController.activeCart[index].quantity <
                                          2)
                                      ? Colors.grey
                                      : Colors.black,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            cartController.activeCart[index].quantity
                                .toString(),
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

  // receipt item
  Widget receiptItem({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          receiptController.receipts[index].code,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cart item detail
            Expanded(
              child: ListView.separated(
                itemCount: receiptController.receipts[index].cart.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int cartIndex) => SizedBox(
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      if (productController.products.indexWhere((element) =>
                              element.name.toLowerCase() ==
                                  receiptController
                                      .receipts[index].cart[cartIndex].product
                                      .toLowerCase() &&
                              element.brand.toLowerCase() ==
                                  receiptController
                                      .receipts[index].cart[cartIndex].brand
                                      .toLowerCase()) >
                          -1) {
                        productController.setCurrentProduct(
                            product: productController.products.firstWhere(
                                (element) =>
                                    element.name.toLowerCase() ==
                                        receiptController.receipts[index]
                                            .cart[cartIndex].product
                                            .toLowerCase() &&
                                    element.brand.toLowerCase() ==
                                        receiptController.receipts[index]
                                            .cart[cartIndex].brand
                                            .toLowerCase()));
                        Get.to(() => const ProductScreen(
                              fromDashboard: false,
                            ));
                      } else {
                        showSnackBar(
                            title: '', message: 'Item no longer found!');
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: cachedImage(
                                  url: receiptController
                                      .receipts[index].cart[cartIndex].image,
                                  contain: false)),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      receiptController.receipts[index]
                                          .cart[cartIndex].product,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    '${receiptController.receipts[index].cart[cartIndex].brand} . ${receiptController.receipts[index].cart[cartIndex].color} . ${receiptController.receipts[index].cart[cartIndex].size.toStringAsFixed(1)} .  (x${receiptController.receipts[index].cart[cartIndex].quantity})',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // cart item price
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Total: '),
                Text(
                  '\$${(receiptController.receipts[index].totalPrice + receiptController.receipts[index].shippingPrice).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '(${receiptController.receipts[index].totalPrice} + ${receiptController.receipts[index].shippingPrice})',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Placed in: '),
                Text(DateTime.fromMillisecondsSinceEpoch(receiptController
                        .receipts[index].placedIn.millisecondsSinceEpoch)
                    .toString()
                    .split(' ')
                    .first),
              ],
            ),
          ],
        )
      ],
    );
  }

  // item review
  Widget reviewItem({bool showAll = false, int stars = 0}) {
    List<ProductReview> temp = receiptController.productReviews
        .where((p0) =>
            p0.productId.toLowerCase() ==
            productController.currentProduct!.value.name.toLowerCase())
        .toList();

    if (stars == 1) {
      temp.removeWhere((element) => element.rating != 1);
    } else if (stars == 2) {
      temp.removeWhere((element) => element.rating != stars);
    } else if (stars == 3) {
      temp.removeWhere((element) => element.rating != stars);
    } else if (stars == 4) {
      temp.removeWhere((element) => element.rating != stars);
    } else if (stars == 5) {
      temp.removeWhere((element) => element.rating != stars);
    }

    return (temp.isEmpty)
        ? const Center(
            child: Text(
              'No reviews found!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            itemCount: (showAll)
                ? temp.length
                : (temp.length > 3)
                    ? 3
                    : temp.length,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 80,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          temp[index].customerId,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                                temp[index].addedIn.millisecondsSinceEpoch)
                            .toString()
                            .split(' ')
                            .first,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      if (temp[index].description.trim().isNotEmpty)
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            temp[index].description,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      Text(
                        '${temp[index].rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: 10,
            ),
          );
  }

  // add to cart for product page
  Future addToCart(
      {required Product product,
      required int attributeIndex,
      required int size}) {
    productController.activeCartTotalPrice(
        (int.parse(productController.quantityController.value.text) *
                product.price)
            .toDouble());

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

                              productController.activeCartTotalPrice((int.parse(
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

                            productController.activeCartTotalPrice((int.parse(
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
              SizedBox(
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
                              '\$${productController.activeCartTotalPrice.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.back();
                        if (int.parse(productController
                                .quantityController.value.text) >
                            0) {
                          await cartController.addToCart(
                              item: product,
                              quantity: int.parse(
                                productController.quantityController.value.text,
                              ),
                              size: size,
                              attributeIndex: attributeIndex);

                          productController.quantityController(
                              TextEditingController(text: '1'));

                          if (await cartController.submitCart()) {
                            addedToCart(
                                quantity: int.parse(productController
                                    .quantityController.value.text));
                          }
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
              SizedBox(
                height: 80,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.offAll(() => const DashboardScreen());
                        },
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
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
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

  // item review bottom sheet
  Future reviewItemBottomSheet({required Product product}) async {
    String userId = (await storageHelper.get(key: Constants().user)).toString();

    ProductReview temp = receiptController.productReviews.firstWhere((p0) =>
        p0.customerId == userId &&
        p0.productId.toLowerCase() == product.name.toLowerCase());

    receiptController.userRating(temp.rating - 1);
    receiptController.userReview(TextEditingController(text: temp.description));

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
              Row(
                children: [
                  const Expanded(
                      child: Text(
                    'Review purchased item',
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
              SizedBox(
                height: 60,
                child: ListView.separated(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => Obx(
                    () => GestureDetector(
                        onTap: () {
                          if (receiptController.userRating.value == index) {
                            receiptController.userRating(-1);
                          } else {
                            receiptController.userRating(index);
                          }
                        },
                        child: Icon(
                          (receiptController.userRating.value <= index - 1)
                              ? Icons.star_border
                              : Icons.star,
                          size: 30,
                        )),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: receiptController.userReview.value,
                      decoration: const InputDecoration(
                          labelText: 'Review',
                          hintText: 'Write something about the product.',
                          border: UnderlineInputBorder()),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        receiptController.submitProductReview(product: product);
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
                            'SUBMIT',
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

  showSnackBar(
      {required String title, required String message, bool isError = false}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      backgroundColor: isError ? Colors.red : Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      icon: (isError) ? const Icon(Icons.error_outline) : null,
    );
  }
}
