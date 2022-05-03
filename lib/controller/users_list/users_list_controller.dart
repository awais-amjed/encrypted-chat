import 'package:appwrite/models.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class UsersListController extends GetxController {
  Rxn<List<CustomUser>> allUsers = Rxn<List<CustomUser>>();
  final DatabaseController _databaseController =
      Get.find(tag: K.databaseControllerTag);

  void getUsers() async {
    allUsers.value = null;
    DocumentList? documentList = await _databaseController.getAllUsers();
    if (documentList == null) {
      allUsers.value = [];
    } else {
      allUsers.value = [];
      for (Document document in documentList.documents) {
        allUsers.value?.add(CustomUser.fromJson(document.data));
      }
    }
  }
}
