import 'package:animate_do/animate_do.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/view/screens/chat_screen.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user, required this.index})
      : super(key: key);

  final CustomUser user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.off(() => ChatScreen(selectedUser: user));
      },
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: 100 * index),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AvatarWidget(
                  size: 35,
                  image: user.imagePath,
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
      ),
    );
  }
}
