import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  GetStorage localStorage = GetStorage();
  GetStorage messageStorage = GetStorage('messages');

  final String _privateKeyHolder = '_privateKey';
  final String _userHolder = 'user';
  final String _themeHolder = 'theme';

  String? readPrivateKey() {
    try {
      UserController _userController = Get.find(tag: K.userControllerTag);
      return localStorage
          .read(_userController.userData.value.id + _privateKeyHolder);
    } catch (e) {
      return null;
    }
  }

  void savePrivateKey({required String privateKey}) async {
    try {
      UserController _userController = Get.find(tag: K.userControllerTag);
      await localStorage.write(
          _userController.userData.value.id + _privateKeyHolder, privateKey);
    } catch (e) {
      return;
    }
  }

  Future<void> saveUser({required CustomUser user}) async {
    await localStorage.write(_userHolder, user.toJson());
  }

  CustomUser? getUser() {
    Map<String, dynamic>? user = localStorage.read(_userHolder);
    if (user != null) {
      return CustomUser.fromJson(user);
    }
    return null;
  }

  List<types.TextMessage>? readMessages({required String collectionID}) {
    return messageStorage.read(collectionID);
  }

  void writeMessages({
    required String collectionID,
    required List<types.TextMessage> data,
  }) async {
    await messageStorage.write(collectionID, data);
  }

  bool? getSavedTheme() {
    return localStorage.read(_themeHolder);
  }

  void saveTheme({required bool theme}) {
    localStorage.write(_themeHolder, theme);
  }
}
