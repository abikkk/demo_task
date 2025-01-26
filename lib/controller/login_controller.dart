import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> username = TextEditingController().obs,
      passcode = TextEditingController().obs;
  RxBool rememberLogin = false.obs;
}
