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

  RxInt activeBrandIndex = (-1).obs, // filter brand
      activeGenderIndex = (-1).obs, // filter gender
      activeSortIndex = (-1).obs, // filter sorting
      activeColorIndex = (-1).obs, // filter color
      filterCount = 0.obs; // filter count

  // UIUtils uiUtils = UIUtils();
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

  setBrand({required int brandIndex}) {
    // if (isDashboard) {
    if (brandIndex == -1) {
      resetFilters();
    } else {
      activeBrandIndex(brandIndex);
      if (filteredProducts.isEmpty) {
        filteredProducts(productController.products
            .where((element) =>
                element.brand.toLowerCase() ==
                brands[activeBrandIndex.value].name.toLowerCase())
            .toList());
      } else {
        filteredProducts.removeWhere((element) =>
            element.brand.toLowerCase() !=
            brands[brandIndex].name.toLowerCase());
      }
      setFilterCount();
    }
  }

  setGender({required int genderIndex}) {
    activeGenderIndex(genderIndex);

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
    setFilterCount();
  }

  setSorting({required int sortIndex}) {
    activeSortIndex(sortIndex);

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
    setFilterCount();
  }

  setColorIndex({required int colorIndex}) {
    activeColorIndex(colorIndex);

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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'black') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'white') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'red') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'blue') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'green') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'orange') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'grey') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'brown') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
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
          var temp = filteredProducts;
          List<int> c = [];
          for (var product in temp) {
            bool containsColor = false;
            for (var attribute in product.attribute) {
              if (attribute.color == 'yellow') {
                containsColor = true;
                break;
              }
            }
            if (!containsColor) c.add(temp.indexOf(product));
          }
          for (var index in c) {
            filteredProducts.removeAt(index);
          }
          // filteredProducts(temp);
        }
    }
    setFilterCount();
  }

  setFilterCount() {
    filterCount(0);
    // filteredProducts.clear();

    // apply brand filter
    if (activeBrandIndex.value > -1) {
      filterCount++;
    }

    // apply gender filter
    if (activeGenderIndex.value > -1) {
      filterCount++;
    }

    // apply sorting filter
    if (activeSortIndex.value > -1) {
      filterCount++;
    }

    // apply color filter
    if (activeColorIndex.value > -1) {
      filterCount++;
    }

    debugPrint(productController.products.length.toString());
  }

  resetFilters() {
    activeBrandIndex(-1);
    activeGenderIndex(-1);
    activeSortIndex(-1);
    activeColorIndex(-1);
    filterCount(0);
    filteredProducts.value = [];
  }
}
