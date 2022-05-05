import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/screens/users_list.dart';
import 'package:ecat/view/widgets/home_screen/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/users_list/users_list_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsersListController _usersListController =
        Get.put(UsersListController(), tag: K.usersListControllerTag);

    _usersListController.getUsers();
    return Scaffold(
      appBar: HelperFunctions.getAppBar(
        title: 'Encrypted Chat',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const UsersList());
        },
        child: const Icon(
          Icons.message,
        ),
      ),
      body: Column(
        children: [
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2015, 9, 15),
          ),
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2022, 1, 15),
          ),
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2022, 5, 3, 19, 51),
          ),
        ],
      ),
    );
  }
}
