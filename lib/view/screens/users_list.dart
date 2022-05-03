import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/users_list_screen/users_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersList extends StatelessWidget {
  UsersList({Key? key}) : super(key: key);

  final UsersListController _usersListController =
      Get.find(tag: K.usersListControllerTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperFunctions.getAppBar(
        title: 'New Message',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              _usersListController.getUsers();
            },
            icon: const Icon(Icons.refresh),
            color: Colors.black,
          ),
        ],
      ),
      body: Obx(
        () => _usersListController.allUsers.value == null
            ? const Center(child: CircularProgressIndicator())
            : _usersListController.allUsers.value!.isEmpty
                ? const Center(child: Text('No User Found'))
                : ListView.builder(
                    itemCount: _usersListController.allUsers.value?.length,
                    itemBuilder: (context, index) => UserListTile(
                      user:
                          _usersListController.allUsers.value!.elementAt(index),
                    ),
                  ),
      ),
    );
  }
}
