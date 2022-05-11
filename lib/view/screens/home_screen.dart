import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/ongoing_chats.dart';
import 'package:ecat/view/widgets/home_screen/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../controller/home/home_controller.dart';
import '../../controller/theme_controller.dart';
import '../widgets/general/notification_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    return GetBuilder<HomeController>(
      builder: (controller) => Stack(
        children: [
          Obx(
            () => ZoomDrawer(
              controller: controller.zoomDrawerController,
              menuScreen: const DrawerScreen(),
              style: DrawerStyle.defaultStyle,
              mainScreen: const OngoingChats(),
              borderRadius: 24.0,
              showShadow: true,
              angle: 0.0,
              drawerShadowsBackgroundColor: Colors.grey,
              slideWidth: MediaQuery.of(context).size.width * 0.65,
              menuBackgroundColor: _themeController.isDarkMode.value
                  ? K.darkPrimary
                  : K.lightPrimary,
              androidCloseOnBackTap: true,
            ),
          ),
          const NotificationWidget(),
        ],
      ),
    );
  }
}
