import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class Loaders {
  Widget dashboardProductLoader() {
    return GridView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: 11,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 15),
      itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade200,
          enabled: true,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: 0.5.sw,
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 5),
          )),
    );
  }

  Widget imageLoader(double? height, double? width) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        enabled: true,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          width: width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 5),
        ));
  }

  Widget receiptLoader() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        enabled: true,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 50,
                  height: 18,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 60,
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 180,
                  height: 18,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 90,
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 180,
                  height: 18,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 80,
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Row(
            //   children: [
            //     Container(
            //       decoration: const BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.all(Radius.circular(20))),
            //       width: 180,
            //       height: 18,
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: [
            //     Container(
            //       decoration: const BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.all(Radius.circular(20))),
            //       width: 180,
            //       height: 18,
            //     ),
            //   ],
            // ),
          ],
        ));
  }

  Future fullScreenLoader() {
    return Get.dialog(
        barrierDismissible: false,
        const SizedBox(
          // color: Colors.white,
          height: 60,
          width: 60,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
