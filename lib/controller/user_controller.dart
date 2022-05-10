import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/notification/notification_controller.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:get/get.dart';

import '../model/constants.dart';

class UserController extends GetxController {
  final Session currentSession;
  late final Rx<CustomUser> userData;

  UserController({required this.currentSession});

  late DatabaseController _databaseController;
  final LocalStorageController _localStorageController =
      Get.find(tag: K.localStorageControllerTag);
  final NotificationController _notificationController =
      Get.put(NotificationController(), tag: K.notificationControllerTag);
  late final UsersListController _usersListController;

  final RxList<String> notificationsList = <String>[].obs;

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
      List<String>? previousChatIDs = _user?.chatIDs;
      if (isInitialized) {
        userData.value = CustomUser.fromJson(remoteData.data);
      } else {
        userData = Rx<CustomUser>(CustomUser.fromJson(remoteData.data));
      }
      _localStorageController.saveUser(user: userData.value);

      if (previousChatIDs != null) {
        synchronizeData();
      }
    }

    startHandlingNotifications();
  }

  void addChatID({required String newID}) {
    userData.value.chatIDs ??= [];
    userData.value.chatIDs?.add(newID);
    _databaseController
        .updateUserData(data: {'chat_ids': userData.value.chatIDs});
  }

  Future<void> updateUserFromRemote() async {
    Document? remoteData =
        await _databaseController.getUser(userID: currentSession.userId);
    if (remoteData != null) {
      userData.value = CustomUser.fromJson(remoteData.data);
      _localStorageController.saveUser(user: userData.value);
    }
  }

  void startHandlingNotifications() async {
    Document? _document = await _databaseController.getDocument(
        collectionID: 'notifications', documentID: currentSession.userId);
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
            _notificationController.currentChat != newNotifications.last) {
          CustomUser? user = _usersListController.allUsers.value
              ?.firstWhere((element) => element.id == newNotifications.last);
          _notificationController.showNotification(name: user?.name);
        }
        notificationsList.value = newNotifications;
      }
    });
  }

  void synchronizeData() async {}
}
