import 'package:ecat/controller/home/home_controller.dart';
import 'package:ecat/view/screens/users_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/constants.dart';
import '../../model/helper_functions.dart';
import '../widgets/ongoing_chats_screen/chat_tile_widget.dart';

class OngoingChats extends GetView<HomeController> {
  const OngoingChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find(tag: K.userControllerTag);

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
          onPressed: () {
            controller.toggleDrawer();
          },
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
      body: Obx(
        () => _userController.onGoingChats.isEmpty
            ? const Center(
                child: Text('Click Message Icon to start a chat'),
              )
            : ListView.builder(
                itemCount: _userController.onGoingChats.length,
                itemBuilder: (context, index) => ChatTileWidget(
                  chatTile: _userController.onGoingChats.elementAt(index),
                ),
              ),
      ),
    );
  }
}