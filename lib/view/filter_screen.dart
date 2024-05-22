import 'package:demo_task/controller/filter_controller.dart';
import 'package:demo_task/view/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../controller/product_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  ProductController productController = Get.find<ProductController>();
  FilterController filterController = Get.find<FilterController>();
  UIUtils uiUtils = UIUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uiUtils.customAppBar(
          title: 'Filter', centerTitled: true, showAction: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // brand filter
              const Text(
                'Brands',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              brandFilterSection(),

              // price filter
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              priceFilterSection(),

              // sort by filter
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              sortFilterSection(),

              // gender filter
              const Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              genderFilterSection(),

              // color filter
              const Text(
                'Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              colorFilterSection()
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => filterController.resetFilters(),
                    child: Obx(
                      () => Text(
                        'Reset (${filterController.filterCount.value})',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 50,
                width: 160,
                child: const Center(
                  child: Text(
                    'APPLY',
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

  Widget brandFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 140,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: filterController.brands.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    filterController.setBrand(brandIndex: index);
                  },
                  child: Column(
                    children: [
                      Obx(
                        () => SizedBox(
                          height: 55,
                          width: 90,
                          child: Stack(
                            children: [
                              Center(
                                child: uiUtils.cachedImage(
                                    url: filterController.brands[index].logo,
                                    contain: true,
                                    height: 40,
                                    width: 40),
                              ),
                              if (filterController.activeBrandIndex.value ==
                                  index)
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.check_circle,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      uiUtils.tipBubbles(
                        title: filterController.brands[index].name,
                        active: true,
                        filterScreen: true,
                      ),
                      Text(
                        '${productController.products.where((p0) => p0.brand.toLowerCase() == filterController.brands[index].name.toLowerCase()).toList().length} items',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 10,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget priceFilterSection() {
    double maxPrice = 20.0, minPrice = 10.0;

    for (var product in productController.products) {
      if (product.price > maxPrice) maxPrice = product.price;
      if (product.price < minPrice) minPrice = product.price;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SfRangeSelector(
              min: minPrice,
              max: maxPrice,
              initialValues: SfRangeValues(minPrice, maxPrice),
              interval: 500,
              showTicks: false,
              showLabels: true,
              stepSize: 5,
              activeColor: Colors.black,
              shouldAlwaysShowTooltip: true,
              enableTooltip: true,
              child: const SizedBox.shrink(),
              onChangeEnd: (vals) {
                filterController.activePriceMin(vals.start);
                filterController.activePriceMax(vals.end);
                filterController.setPricing(max: maxPrice, min: minPrice);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget sortFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 50,
      child: Obx(
        () => Row(
          children: [
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => filterController.setSorting(sortIndex: 0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (filterController.activeSortIndex.value == 0)
                            ? Colors.black
                            : Colors.white),
                    child: Center(
                      child: Text(
                        'Most Recent',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: (filterController.activeSortIndex.value == 0)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setSorting(sortIndex: 1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (filterController.activeSortIndex.value == 1)
                            ? Colors.black
                            : Colors.white),
                    child: Center(
                      child: Text(
                        'Lowest Price',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: (filterController.activeSortIndex.value == 1)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setSorting(sortIndex: 2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (filterController.activeSortIndex.value == 2)
                            ? Colors.black
                            : Colors.white),
                    child: Center(
                      child: Text(
                        'Highest Price',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: (filterController.activeSortIndex.value == 2)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget genderFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 50,
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => filterController.setGender(genderIndex: 1),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 35,
                  // width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (filterController.activeGenderIndex.value == 1)
                          ? Colors.black
                          : Colors.white),
                  child: Center(
                    child: Text(
                      'Male',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: (filterController.activeGenderIndex.value == 1)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => filterController.setGender(genderIndex: 2),
                child: Container(
                  height: 35,
                  // width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (filterController.activeGenderIndex.value == 2)
                          ? Colors.black
                          : Colors.white),
                  child: Center(
                    child: Text(
                      'Female',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: (filterController.activeGenderIndex.value == 2)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => filterController.setGender(genderIndex: 0),
                child: Container(
                  height: 35,
                  // width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (filterController.activeGenderIndex.value == 0)
                          ? Colors.black
                          : Colors.white),
                  child: Center(
                    child: Text(
                      'Unisex',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: (filterController.activeGenderIndex.value == 0)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget colorFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 40,
      child: Obx(
        () => Row(
          children: [
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 0)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Black',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 1)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                        const Text(
                          'White',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 2)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Red',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 3),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 3)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Blue',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 4),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 4)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Green',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 5),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 5)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.orange, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Orange',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 6),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 6)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Grey',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 7),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 7)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.brown, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Brown',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => filterController.setColorIndex(colorIndex: 8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: (filterController.activeColorIndex.value == 8)
                              ? Colors.black
                              : Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                              color: Colors.yellow, shape: BoxShape.circle),
                        ),
                        const Text(
                          'Yellow',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
