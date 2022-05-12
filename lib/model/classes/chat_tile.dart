import 'package:ecat/model/classes/custom_user.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum MessageStatus {
  newUser,
  read,
  unRead,
}

class ChatTile {
  CustomUser user;
  Rx<MessageStatus> messageStatus;

  ChatTile({required this.user, required this.messageStatus});
}
