import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = true.obs;

  void changeTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void darkMode() {
    // TODO Colors to be decided
  }

  void lightMode() {
    // TODO Colors to be decided
  }
}
