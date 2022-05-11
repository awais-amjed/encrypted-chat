import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/widgets/general/CustomNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({Key? key, required this.size, this.image})
      : super(key: key);

  final double size;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _themeController.isDarkMode.value
                ? K.darkSecondary
                : K.lightSecondary,
            width: size / 10,
          ),
          borderRadius: BorderRadius.circular(1000),
          color: Colors.white,
        ),
        child: ClipOval(
          child: Padding(
            padding: EdgeInsets.all(size / 5),
            child: CustomNetworkImage(
              url: image,
              width: size,
              height: size,
            ),
          ),
        ),
      ),
    );
  }
}
