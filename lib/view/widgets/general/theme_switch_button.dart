import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    return SizedBox(
      width: 100,
      child: Obx(
        () => FlutterSwitch(
          width: 100,
          height: 45.0,
          toggleSize: 28.0,
          value: _themeController.isDarkMode.value,
          borderRadius: 17.0,
          padding: 2.0,
          activeToggleColor: K.darkAppbar,
          inactiveToggleColor: const Color(0xFF2F363D),
          activeSwitchBorder: Border.all(
            color: K.darkSecondary,
            width: 6.0,
          ),
          inactiveSwitchBorder: Border.all(
            color: const Color(0xFFD1D5DA),
            width: 6.0,
          ),
          activeColor: K.darkSecondary,
          inactiveColor: Colors.white,
          activeIcon: const Icon(
            Icons.nightlight_round,
            color: Color(0xFFF8E3A1),
          ),
          inactiveIcon: const Icon(
            Icons.wb_sunny,
            color: Color(0xFFFFDF5D),
          ),
          onToggle: (val) {
            _themeController.changeTheme();
          },
        ),
      ),
    );
  }
}
