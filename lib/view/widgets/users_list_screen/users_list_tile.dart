import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/view/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general/CustomNetworkImage.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user}) : super(key: key);

  final CustomUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.off(() => const ChatScreen());
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipOval(
                child: CustomNetworkImage(
                  url: user.imageURL,
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  user.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
