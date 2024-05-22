import 'package:demo_task/constants.dart';
import 'package:demo_task/controller/cart_controller.dart';
import 'package:demo_task/controller/filter_controller.dart';
import 'package:demo_task/controller/product_controller.dart';
import 'package:demo_task/controller/receipt_controller.dart';
import 'package:demo_task/model/brand_model.dart';
import 'package:demo_task/view/filter_screen.dart';
import 'package:demo_task/view/loader_helpers.dart';
import 'package:demo_task/view/product_screen.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../model/product_review_model.dart';
import '../storage_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StorageHelper storageHelper = StorageHelper(); // storage helper
  CartController cartController = Get.put(CartController(), permanent: true);
  ProductController productController =
      Get.put(ProductController(), permanent: true);
  ReceiptController receiptController =
      Get.put(ReceiptController(), permanent: true);
  FilterController filterController =
      Get.put(FilterController(), permanent: true);

  UIUtils uiUtils = UIUtils();
  Loaders loaders = Loaders();
  Constants constants = Constants();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
  }

  setUser() async {
    if ((await storageHelper.get(key: constants.user)).toString() == '') {
      receiptController.createNewUser();
    } else {
      receiptController.createNewUser(user: int.parse(
          (await storageHelper.get(key: constants.user)).toString()));
      // receiptController.createNewUser();
      debugPrint(
          '## current user ID: ${await storageHelper.get(key: constants.user)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uiUtils.customAppBar(title: 'Discover'),
      body: RefreshIndicator(
        onRefresh: () async {
          filterController.resetFilters();
          productController.onInit();
          receiptController.onInit();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  // brand filter
                  brandFilterRow(),

                  // product list
                  (!productController.productsLoaded.value)
                      ? loaders.dashboardProductLoader()
                      : (filterController.filterCount.value > 0 &&
                              filterController.filteredProducts.isEmpty)
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text('No products for such filter(s)!'),
                            )
                          : (filterController.filterCount.value == 0 &&
                                  productController.products.isEmpty)
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.0),
                                  child: Text('No products available.'),
                                )
                              : productList(),

                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
    );
  }

  // brand filter fow
  Widget brandFilterRow() {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          GestureDetector(
              onLongPress: () {
                uiUtils.selectUser();
              },
              onTap: () {
                filterController.setBrandFilter(brandIndex: -1);
              },
              child: uiUtils.tipBubbles(
                  title: 'All',
                  active: filterController.activeBrandIndex.value == -1)),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: filterController.brands.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  filterController.setBrandFilter(
                      brandIndex: index, isDashboard: true);
                },
                child: uiUtils.tipBubbles(
                    title: filterController.brands[index].name,
                    active: filterController.activeBrandIndex.value == index),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 10,
              );
            },
          ))
        ],
      ),
    );
  }

  GridView productList() {
    return GridView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: filterController.filteredProducts.isNotEmpty
          ? filterController.filteredProducts.length
          : productController.products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            productController.setCurrentProduct(
                product: (filterController.filteredProducts.isNotEmpty)
                    ? filterController.filteredProducts[index]
                    : productController.products[index]);

            Get.to(() => const ProductScreen());
          },
          child: uiUtils.product(
              product: (filterController.filteredProducts.isNotEmpty)
                  ? filterController.filteredProducts[index]
                  : productController.products[index]),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 2,
          mainAxisSpacing: 15),
    );
  }
}
