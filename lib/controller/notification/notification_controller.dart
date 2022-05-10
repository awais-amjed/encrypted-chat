import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final Map<Routes, AnimationController?> animationControllers = {};
  RxString message = 'You have a new message'.obs;
  String? currentChat;

  void showNotification({String? name}) {
    if (name != null) {
      message.value = '$name sent a message';
    } else {
      message.value = 'You have a new message';
    }

    Routes? route = GetRoute.getEnumFromRoute(route: Get.currentRoute);
    if (route == null) {
      return;
    }
    AnimationController? _controller = animationControllers[route];
    _controller?.forward().then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        _controller.reverse();
      });
    });
  }
}

enum Routes {
  home,
  usersList,
  chatScreen,
}

extension GetRoute on Routes {
  static Routes? getEnumFromRoute({required String route}) {
    switch (route) {
      case '/HomeScreen':
        return Routes.home;
      case '/UsersList':
        return Routes.usersList;
      case '/ChatScreen':
        return Routes.chatScreen;
      default:
        return null;
    }
  }
}
