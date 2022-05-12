import 'package:animate_do/animate_do.dart';
import 'package:ecat/model/classes/chat_tile.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/chat_screen.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/user_controller.dart';

class ChatTileWidget extends StatelessWidget {
  const ChatTileWidget({
    Key? key,
    required this.chatTile,
    required this.index,
  }) : super(key: key);

  final ChatTile chatTile;
  final int index;

  @override
  Widget build(BuildContext context) {
    RxBool loading = false.obs;

    return GestureDetector(
      onTap: () {
        if (!(chatTile.messageStatus.value == MessageStatus.newUser)) {
          Get.to(() => ChatScreen(selectedUser: chatTile.user));
        }
      },
      child: SlideInLeft(
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: 100 * index),
        child: Container(
          height: 100,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4.w),
          child: Row(
            children: [
              AvatarWidget(
                size: 50,
                image: chatTile.user.imagePath,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatTile.user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Obx(
                      () => Text(
                        chatTile.messageStatus.value == MessageStatus.newUser
                            ? 'A new person wants to connect'
                            : chatTile.messageStatus.value ==
                                    MessageStatus.unRead
                                ? 'ooh new messages'
                                : 'Nothing to see here',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => chatTile.messageStatus.value == MessageStatus.read
                    ? Image.asset(
                        'assets/icons/sleep.png',
                        height: 40,
                      )
                    : chatTile.messageStatus.value == MessageStatus.newUser
                        ? ElevatedButton(
                            onPressed: () async {
                              loading.value = true;
                              final UserController _ =
                                  Get.find(tag: K.userControllerTag);
                              if (await _.addChatID(
                                  newID: chatTile.user.id, update: true)) {
                                Get.to(() =>
                                    ChatScreen(selectedUser: chatTile.user));
                              }
                              loading.value = false;
                            },
                            child: loading.value
                                ? const CircularProgressIndicator()
                                : const Text('Accept'),
                          )
                        : Image.asset(
                            'assets/icons/notification.png',
                            height: 40,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
