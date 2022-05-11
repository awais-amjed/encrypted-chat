import 'package:ecat/controller/notification/notification_controller.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with SingleTickerProviderStateMixin {
  final NotificationController _notificationController =
      Get.find(tag: K.notificationControllerTag);
  final ThemeController _themeController = Get.find(tag: K.themeControllerTag);

  late final Animation<Offset> _offsetAnimation;
  Routes? route;

  @override
  void initState() {
    super.initState();
    route = GetRoute.getEnumFromRoute(route: Get.currentRoute);

    _notificationController.animationControllers[route!] = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0.5),
    ).animate(CurvedAnimation(
      parent: _notificationController.animationControllers[route]!,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _notificationController.animationControllers[route]!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Obx(
          () => Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: _themeController.isDarkMode.value
                ? K.darkSecondary
                : K.lightPrimary,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Obx(
                      () => Text(
                        _notificationController.message.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      _notificationController.animationControllers[route!]!
                          .reverse();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
