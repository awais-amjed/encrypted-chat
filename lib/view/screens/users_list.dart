import 'package:ecat/controller/notification/notification_controller.dart';
import 'package:ecat/controller/users_list/users_list_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/users_list_screen/users_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/general/notification_widget.dart';

class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsersListController _usersListController =
        Get.find(tag: K.usersListControllerTag);
    final NotificationController _notificationController =
        Get.find(tag: K.notificationControllerTag);

    return Stack(
      children: [
        Scaffold(
          appBar: HelperFunctions.getAppBar(
            title: 'New Message',
            actions: [
              IconButton(
                onPressed: () {
                  _notificationController.showNotification();
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  _usersListController.getUsers();
                },
                icon: const Icon(Icons.refresh),
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
                        itemBuilder: (context, index) => Padding(
                          padding: index == 0
                              ? const EdgeInsets.only(top: 20.0)
                              : EdgeInsets.zero,
                          child: UserListTile(
                            user: _usersListController.allUsers.value!
                                .elementAt(index),
                          ),
                        ),
                      ),
          ),
        ),
        const NotificationWidget(),
      ],
    );
  }
}
