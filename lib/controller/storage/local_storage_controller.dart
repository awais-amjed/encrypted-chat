import 'package:ecat/model/classes/custom_user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  GetStorage localStorage = GetStorage();
  GetStorage messageStorage = GetStorage('messages');

  final String _privateKeyHolder = 'privateKey';
  final String _userHolder = 'user';

  String? readPrivateKey() {
    return localStorage.read(_privateKeyHolder);
  }

  void savePrivateKey({required String privateKey}) async {
    await localStorage.write(_privateKeyHolder, privateKey);
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

  String? readMessages({required String collectionID}) {
    return messageStorage.read(collectionID);
  }

  void writeMessages(
      {required String collectionID, required String data}) async {
    await messageStorage.write(collectionID, data);
  }
}
