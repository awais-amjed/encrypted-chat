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

  @override
  void onInit() async {
    super.onInit();

    DatabaseController _databaseController = Get.put(
      DatabaseController(session: currentSession),
      tag: K.databaseControllerTag,
      permanent: true,
    );

    // Gets locally saved user data and updates it with new user data
    LocalStorageController _localStorageController =
        Get.find(tag: K.localStorageControllerTag);
    final CustomUser? _user = _localStorageController.getUser();
    if (_user != null) {
      userData = Rx<CustomUser>(_user);
    }

    Document? remoteData =
        await _databaseController.getUser(userID: currentSession.userId);
    if (remoteData != null) {
      userData = Rx<CustomUser>(CustomUser.fromJson(remoteData.data));
      _localStorageController.saveUser(user: userData.value);
    }
  }
}
