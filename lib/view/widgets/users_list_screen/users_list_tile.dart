import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/view/screens/chat_screen.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user}) : super(key: key);

  final CustomUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.off(() => ChatScreen(selectedUser: user));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AvatarWidget(
                size: 35,
                image: user.imageURL,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
