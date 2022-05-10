import 'package:appwrite/models.dart';
import 'package:ecat/controller/notification/notification_controller.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:ecat/model/classes/chat_tile.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:get/get.dart';

import '../model/constants.dart';

class UserController extends GetxController {
  final Session currentSession;
  late final Rx<CustomUser> userData;

  UserController({required this.currentSession});

  late DatabaseController _databaseController;
  late final UsersListController _usersListController;
  final LocalStorageController _localStorageController =
      Get.find(tag: K.localStorageControllerTag);
  late final NotificationController _notificationController;

  final RxList<ChatTile> onGoingChats = <ChatTile>[].obs;

  @override
  void onInit() async {
    super.onInit();

    _databaseController = Get.put(
      DatabaseController(session: currentSession),
      tag: K.databaseControllerTag,
      permanent: true,
    );
    _usersListController = Get.put(
      UsersListController(currentUserID: currentSession.userId),
      tag: K.usersListControllerTag,
      permanent: true,
    );
    _notificationController = Get.put(
      NotificationController(userID: currentSession.userId),
      tag: K.notificationControllerTag,
      permanent: true,
    );

    // Gets locally saved user data and updates it with new user data
    final CustomUser? _user = _localStorageController.getUser();
    bool isInitialized = false;
    if (_user != null) {
      userData = Rx<CustomUser>(_user);
      isInitialized = true;
    }

    Document? remoteData =
        await _databaseController.getUser(userID: currentSession.userId);
    if (remoteData != null) {
      if (isInitialized) {
        userData.value = CustomUser.fromJson(remoteData.data);
      } else {
        userData = Rx<CustomUser>(CustomUser.fromJson(remoteData.data));
      }
      _localStorageController.saveUser(user: userData.value);
    }

    if (_usersListController.allUsers.value != null &&
        userData.value.chatIDs != null) {
      _usersListController.allUsers.value?.forEach((_user) {
        if (userData.value.chatIDs!.contains(_user.id)) {
          onGoingChats.add(
              ChatTile(user: _user, messageStatus: MessageStatus.read.obs));
        }
      });
    }

    _notificationController.startHandlingNotifications(
        onListChange: updateChatsStatus);
  }

  void chatStatusRead({required String userID}) {
    onGoingChats
        .firstWhereOrNull((element) => element.user.id == userID)
        ?.messageStatus
        .value = MessageStatus.read;
  }

  void updateChatsStatus({required List<String> notifications}) {
    List<String> ids = [];
    for (String element in notifications) {
      ids.add(element);
    }
    for (ChatTile chatTile in onGoingChats) {
      if (ids.remove(chatTile.user.id)) {
        chatTile.messageStatus.value = MessageStatus.unRead;
      }
    }
    for (String newID in ids) {
      CustomUser? _user = _usersListController.allUsers.value
          ?.firstWhereOrNull((element) => element.id == newID);
      if (_user != null) {
        onGoingChats.add(
          ChatTile(
            user: _user,
            messageStatus: MessageStatus.newUser.obs,
          ),
        );
      }
    }
  }

  Future<bool> addChatID({required String newID, bool update = false}) async {
    Document? document;
    List<String>? newIDs = userData.value.chatIDs;
    newIDs ??= [];
    newIDs.add(newID);
    await _databaseController
        .updateUserData(data: {'chat_ids': newIDs}).then((value) {
      document = value;
      userData.value.chatIDs ??= [];
      userData.value.chatIDs?.add(newID);

      CustomUser? _user = _usersListController.allUsers.value
          ?.firstWhere((user) => user.id == newID);
      if (_user != null) {
        if (update) {
          onGoingChats
              .elementAt(onGoingChats
                  .indexWhere((element) => element.user.id == _user.id))
              .messageStatus
              .value = MessageStatus.read;
        } else {
          onGoingChats.add(
              ChatTile(user: _user, messageStatus: MessageStatus.read.obs));
        }
      }
    }).catchError(K.showErrorToast);
    return document == null ? false : true;
  }

  Future<void> updateUserFromRemote() async {
    Document? remoteData =
        await _databaseController.getUser(userID: currentSession.userId);
    if (remoteData != null) {
      userData.value = CustomUser.fromJson(remoteData.data);
      _localStorageController.saveUser(user: userData.value);
    }
  }
}
