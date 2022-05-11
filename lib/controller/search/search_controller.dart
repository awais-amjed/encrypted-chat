import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:ecat/model/classes/chat_tile.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final RxList<ChatTile> searchedChats = <ChatTile>[].obs;
  final RxList<CustomUser> searchedUsers = <CustomUser>[].obs;

  final UserController _userController = Get.find(tag: K.userControllerTag);
  final UsersListController _usersListController =
      Get.find(tag: K.usersListControllerTag);

  final RxBool hasDataChats = false.obs;
  final RxBool hasDataUsers = false.obs;

  void searchChats({required String query}) {
    hasDataChats.value = query != '';
    searchedChats.clear();
    searchedChats.value = _userController.onGoingChats
        .where((value) =>
            value.user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void searchUsers({required String query}) {
    hasDataUsers.value = query != '';
    searchedUsers.clear();
    if (_usersListController.allUsers.value != null) {
      searchedUsers.value = _usersListController.allUsers.value!
          .where(
              (value) => value.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
