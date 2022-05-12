import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';
import '../../../model/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    this.initial,
    required this.image,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? initial;
  final String image;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);
    final TextEditingController _textController = TextEditingController();
    if (initial != null) {
      _textController.text = initial!;
    }

    return Obx(
      () => TextField(
        controller: _textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          label: Text(label),
          icon: Image.asset(
            image,
            width: 50,
          ),
        ),
        style: TextStyle(
            color: _themeController.isDarkMode.value
                ? Colors.white
                : Colors.black),
        onChanged: (_) {
          onChange(_);
        },
      ),
    );
  }
}
