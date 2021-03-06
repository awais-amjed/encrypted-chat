import 'package:appwrite/models.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class UsersListController extends GetxController {
  Rxn<List<CustomUser>> allUsers = Rxn<List<CustomUser>>();
  final DatabaseController _databaseController =
      Get.find(tag: K.databaseControllerTag);
  String currentUserID;

  UsersListController({required this.currentUserID});

  void setUserID({required String userID}) {
    currentUserID = userID;
  }

  Future<void> getUsers() async {
    allUsers.value = null;
    DocumentList? documentList = await _databaseController.getAllUsers();
    if (documentList == null) {
      allUsers.value = [];
    } else {
      allUsers.value = [];
      for (Document document in documentList.documents) {
        CustomUser _temp = CustomUser.fromJson(document.data);
        if (_temp.publicKey != null && _temp.id != currentUserID) {
          allUsers.value?.add(_temp);
        }
      }
    }
  }
}
