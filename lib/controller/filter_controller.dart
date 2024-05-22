import 'package:demo_task/controller/product_controller.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../model/brand_model.dart';
import '../model/product_model.dart';
import '../view/ui_helpers.dart';

class FilterController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  Constants constants = Constants();
  RxList<Brand> brands = <Brand>[].obs; // brand list

  ProductController productController = Get.find<ProductController>();
  RxList<Product> filteredProducts = <Product>[].obs; // filtered product list
  RxBool hasPriceRange = false.obs; // filter price
  RxDouble activePriceMin = 0.0.obs,
      activePriceMax = 0.0.obs; // price range filter
  RxInt activeBrandIndex = (-1).obs, // filter brand
      activeGenderIndex = (-1).obs, // filter gender
      activeSortIndex = (-1).obs, // filter sorting
      activeColorIndex = (-1).obs, // filter color
      filterCount = 0.obs; // filter count

  // UIUtils uiUtils = UIUtils();
  @override
  onInit() {
    getBrands();
    super.onInit();
  }

  getBrands() async {
    try {
      debugPrint('## getting brands list');

      final snapShot = await firebase.collection(constants.brands).get();
      // for (var element in snapShot.docs) {
      //   debugPrint(element.data().toString().replaceAll(', ', '\n'));
      // }

      brands(snapShot.docs.map((e) => Brand.fromSnapShot(e)).toList());
      brands.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      // uiUtils.showSnackBar(
      //     title: 'Error', message: 'Error getting products.', isError: true);
      debugPrint('## ERROR GETTING BRANDS: $e');
    } finally {
      debugPrint('## brands list count: ${brands.length}');
    }
  }

  setBrandFilter({required int brandIndex, bool isDashboard = false}) {
    activeBrandIndex(brandIndex);
    // if (isDashboard) {
    //   setFilterCount();
    // } else
    if (brandIndex == -1) {
      resetFilters();
    } else {
      setFilterCount();
    }
  }

  setPricingFilter({required double max, required double min}) {
    hasPriceRange(activePriceMin.value > min || activePriceMax.value < max);
    setFilterCount();
  }

  setSortByFilter({required int sortIndex}) {
    activeSortIndex(sortIndex);
    setFilterCount();
  }

  setGenderFilter({required int genderIndex}) {
    activeGenderIndex(genderIndex);
    setFilterCount();
  }

  setColorFilter({required int colorIndex}) {
    activeColorIndex(colorIndex);
    setFilterCount();
  }

  setFilterCount() {
    filterCount(0);
    filteredProducts.clear();

    // apply brand filter
    if (activeBrandIndex.value > -1) {
      filteredProducts(productController.products
          .where((element) =>
              element.brand.toLowerCase() ==
              brands[activeBrandIndex.value].name.toLowerCase())
          .toList());
      filterCount++;
    }

    // apply sorting filter
    if (activeSortIndex.value > -1) {
      switch (activeSortIndex.value) {
        case 0:
          if (filteredProducts.isEmpty) {
            filteredProducts.value = productController.products
              ..toList().sort((a, b) => a.added.compareTo(b.added));
          }
          filteredProducts.sort((a, b) => a.added.compareTo(b.added));
        case 1:
          if (filteredProducts.isEmpty) {
            filteredProducts.value = productController.products
              ..toList().sort((a, b) => a.added.compareTo(b.added));
          }
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        case 2:
          if (filteredProducts.isEmpty) {
            filteredProducts.value = productController.products
              ..toList().sort((a, b) => a.added.compareTo(b.added));
          }
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      }
      filterCount++;
    }

    // apply price range filter
    if (hasPriceRange.value) {
      if (hasPriceRange.value) {
        if (filteredProducts.isEmpty) {
          filteredProducts.value = productController.products
              .where((p0) =>
                  p0.price < activePriceMax.value &&
                  p0.price > activePriceMin.value)
              .toList();
        } else {
          filteredProducts.removeWhere((element) =>
              !(element.price < activePriceMax.value &&
                  element.price > activePriceMin.value));
        }
      }
      filterCount++;
    }

    // apply gender filter
    if (activeGenderIndex.value > -1) {
      switch (activeGenderIndex.value) {
        case 0:
          if (filteredProducts.isEmpty) {
            filteredProducts(productController.products
                .where((element) => element.gender.toLowerCase() == 'unisex')
                .toList());
          } else {
            filteredProducts.removeWhere(
                (element) => element.gender.toLowerCase() != 'unisex');
          }
        case 1:
          if (filteredProducts.isEmpty) {
            filteredProducts(productController.products
                .where((element) => element.gender.toLowerCase() == 'male')
                .toList());
          } else {
            filteredProducts.removeWhere(
                (element) => element.gender.toLowerCase() != 'unisex');
          }
        case 2:
          if (filteredProducts.isEmpty) {
            filteredProducts(productController.products
                .where((element) => element.gender.toLowerCase() == 'female')
                .toList());
          } else {
            filteredProducts.removeWhere(
                (element) => element.gender.toLowerCase() != 'unisex');
          }
      }
      filterCount++;
    }

    // apply color filter
    if (activeColorIndex.value > -1) {
      switch (activeColorIndex.value) {
        case 0:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'black') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'black') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 1:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'white') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'white') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 2:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'red') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'red') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 3:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'blue') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'blue') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 4:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'green') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'green') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 5:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'orange') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'orange') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 6:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'grey') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'grey') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 7:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'brown') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'brown') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
        case 8:
          if (filteredProducts.isEmpty) {
            for (var product in productController.products) {
              for (var attribute in product.attribute) {
                if (attribute.color == 'yellow') {
                  filteredProducts.add(product);
                  break;
                }
              }
            }
          } else {
            List<Product> temp = [];
            for (var product in filteredProducts) {
              bool containsColor = false;
              for (var attribute in product.attribute) {
                if (attribute.color == 'yellow') {
                  containsColor = true;
                  break;
                }
              }
              if (!containsColor) temp.add(product);
            }
            for (var unProduct in temp) {
              filteredProducts.remove(unProduct);
            }
          }
      }
      filterCount++;
    }
  }

  resetFilters() {
    activeBrandIndex(-1);
    activeGenderIndex(-1);
    hasPriceRange(false);
    // activePriceMax(0.0);
    // activePriceMin(0.0);
    activeSortIndex(-1);
    activeColorIndex(-1);
    filterCount(0);
    filteredProducts.value = [];
  }
}
