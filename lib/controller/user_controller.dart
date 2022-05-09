import 'package:appwrite/models.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:get/get.dart';

import '../model/constants.dart';

class UserController extends GetxController {
  final Session currentSession;
  late final Rx<CustomUser> userData;

  UserController({required this.currentSession});

  late DatabaseController _databaseController;

  @override
  void onInit() async {
    super.onInit();

    _databaseController = Get.put(
      DatabaseController(session: currentSession),
      tag: K.databaseControllerTag,
      permanent: true,
    );

    // Gets locally saved user data and updates it with new user data
    LocalStorageController _localStorageController =
        Get.find(tag: K.localStorageControllerTag);
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
  }

  void addChatID({required String newID}) {
    userData.value.chatIDs ??= [];
    userData.value.chatIDs?.add(newID);
    _databaseController
        .updateUserData(data: {'chat_ids': userData.value.chatIDs});
  }

  void synchronizeData() async {}
}
