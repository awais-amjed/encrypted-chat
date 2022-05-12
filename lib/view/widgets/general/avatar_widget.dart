import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/widgets/general/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.size,
    this.image,
    this.imageFile,
    this.borderWidth,
  }) : super(key: key);

  final double size;
  final String? image;
  final File? imageFile;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    final bool padding =
        ((image == null || image!.contains('assets/images/saved')) &&
                    imageFile == null) ==
                true
            ? true
            : false;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _themeController.isDarkMode.value
                ? K.darkSecondary
                : K.lightSecondary,
            width: borderWidth ?? (size / 10),
          ),
          borderRadius: BorderRadius.circular(1000),
          color: Colors.white,
        ),
        child: ZoomIn(
          child: Padding(
            padding: padding ? EdgeInsets.all(size / 5) : EdgeInsets.zero,
            child: imageFile != null
                ? ClipOval(
                    child: Image.file(
                      imageFile!,
                      width: !padding ? (size / 5) * 2 + size : size,
                      height: !padding ? (size / 5) * 2 + size : size,
                      fit: BoxFit.cover,
                    ),
                  )
                : CustomNetworkImage(
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
