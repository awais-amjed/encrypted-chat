import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../model/classes/custom_user.dart';
import '../../model/constants.dart';

class NotificationController extends GetxController {
  final String userID;

  final RxList<String> notificationsList = <String>[].obs;

  final Map<Routes, AnimationController?> animationControllers = {};
  RxString message = 'You have a new message'.obs;
  String? currentChat;

  final DatabaseController _databaseController =
      Get.find(tag: K.databaseControllerTag);
  final UsersListController _usersListController =
      Get.find(tag: K.usersListControllerTag);

  NotificationController({required this.userID});

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

  void removeUser({required String userIDToRemove}) {
    if (notificationsList.remove(userIDToRemove)) {
      _databaseController.updateDocument(
        collectionID: 'notifications',
        documentID: userID,
        data: {
          'user_ids': notificationsList.value,
        },
      ).catchError((e) {
        notificationsList.add(userIDToRemove);
      });
    }
  }

  void startHandlingNotifications() async {
    Document? _document = await _databaseController.getDocument(
        collectionID: 'notifications', documentID: userID);
    if (_document != null) {
      if (_document.data['user_ids'] != null) {
        notificationsList.value = _document.data['user_ids']
            .map<String>((e) => e.toString())
            .toList();
      }
    }

    RealtimeSubscription _notificationSubscription =
        _databaseController.subscribeToNotifications();
    _notificationSubscription.stream.listen((event) {
      if (event.event == 'database.documents.update') {
        final List<String> newNotifications =
            event.payload['user_ids'].map<String>((e) => e.toString()).toList();
        if (newNotifications.length > notificationsList.length &&
            currentChat != newNotifications.last) {
          CustomUser? user = _usersListController.allUsers.value
              ?.firstWhere((element) => element.id == newNotifications.last);
          showNotification(name: user?.name);
        }
        notificationsList.value = newNotifications;
      }
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
