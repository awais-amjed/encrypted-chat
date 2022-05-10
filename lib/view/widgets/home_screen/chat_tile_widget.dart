import 'package:ecat/model/classes/chat_tile.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/chat_screen.dart';
import 'package:ecat/view/widgets/general/CustomNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';

class ChatTileWidget extends StatelessWidget {
  const ChatTileWidget({
    Key? key,
    required this.chatTile,
  }) : super(key: key);

  final ChatTile chatTile;

  @override
  Widget build(BuildContext context) {
    RxBool loading = false.obs;

    return GestureDetector(
      onTap: () {
        if (!(chatTile.messageStatus.value == MessageStatus.newUser)) {
          Get.to(() => ChatScreen(selectedUser: chatTile.user));
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  print('nice');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipOval(
                    child: CustomNetworkImage(
                      url: chatTile.user.imageURL,
                      fit: BoxFit.cover,
                      height: 65,
                      width: 65,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    chatTile.user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Obx(
                () => chatTile.messageStatus.value == MessageStatus.newUser
                    ? TextButton(
                        onPressed: () async {
                          loading.value = true;
                          final UserController _ =
                              Get.find(tag: K.userControllerTag);
                          if (await _.addChatID(
                              newID: chatTile.user.id, update: true)) {
                            Get.to(
                                () => ChatScreen(selectedUser: chatTile.user));
                          }
                          loading.value = false;
                        },
                        child: loading.value
                            ? const CircularProgressIndicator()
                            : const Text('Accept'),
                      )
                    : Column(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: chatTile.messageStatus.value ==
                                    MessageStatus.unRead
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
