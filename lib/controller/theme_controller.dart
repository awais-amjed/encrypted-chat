import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = true.obs;
  final LocalStorageController _localStorageController =
      Get.find(tag: K.localStorageControllerTag);

  @override
  void onInit() {
    super.onInit();

    bool? savedTheme = _localStorageController.getSavedTheme();
    if (savedTheme != null) {
      isDarkMode.value = savedTheme;
    }
  }

  void changeTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _localStorageController.saveTheme(theme: isDarkMode.value);
  }

  void darkMode() {
    // TODO Colors to be decided
  }

  void lightMode() {
    // TODO Colors to be decided
  }
}
