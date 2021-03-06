import 'package:ecat/controller/chat/chat_controller.dart';
import 'package:ecat/controller/notification/notification_controller.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.selectedUser}) : super(key: key);

  final CustomUser selectedUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  late types.User _me;
  late types.User _you;

  late ChatController _chatController;

  final NotificationController _notificationController =
      Get.find(tag: K.notificationControllerTag);
  final ThemeController _themeController = Get.find(tag: K.themeControllerTag);

  @override
  void initState() {
    super.initState();

    _notificationController.currentChat = widget.selectedUser.id;

    _you = types.User(
      id: widget.selectedUser.id,
      firstName: widget.selectedUser.name,
      imageUrl: widget.selectedUser.imagePath,
    );

    UserController _userController = Get.find(tag: K.userControllerTag);
    _me = types.User(
      id: _userController.userData.value.id,
      firstName: _userController.userData.value.name,
      imageUrl: _userController.userData.value.imagePath,
    );

    _chatController = Get.put(ChatController(
      user1: _userController.userData.value,
      user2: widget.selectedUser,
      setUIMessages: _setMessages,
      addMessageToUI: _addMessage,
      addMessagesAtEnd: _addMessagesAtEnd,
    ));
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _addMessagesAtEnd(List<types.TextMessage> messages) {
    setState(() {
      _messages.addAll(messages);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    types.TextMessage textMessage = types.TextMessage(
      author: _me,
      id: const Uuid().v4(),
      text: message.text,
      showStatus: true,
      status: types.Status.sending,
    );

    _addMessage(textMessage);
    _chatController
        .addMessage(
          message: textMessage,
          afterMagic: (status) {
            int index = _messages.indexOf(textMessage);
            setState(() {
              textMessage = _messages[index].copyWith(status: status)
                  as types.TextMessage;
              _messages[index] = textMessage;
            });
          },
        )
        .catchError(K.showErrorToast);
  }

  void _setMessages(List<types.TextMessage> messages) {
    setState(() {
      _messages.clear();
      _messages.addAll(messages.reversed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        destroy();
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: HelperFunctions.getAppBar(title: widget.selectedUser.name),
            body: Chat(
              user: _me,
              onSendPressed: _handleSendPressed,
              messages: _messages,
              onEndReachedThreshold: 1,
              onEndReached: () async {
                _chatController.loadMoreMessages();
              },
              onTextChanged: (_) {
                if (_.length > 240) {
                  K.showDialog(
                    context: context,
                    title: 'Max Length reached',
                  );
                }
              },
              theme: _themeController.isDarkMode.value
                  ? const DarkChatTheme(
                      backgroundColor: K.darkPrimary,
                      inputBackgroundColor: K.darkAppbar,
                      messageBorderRadius: 12,
                    )
                  : const DefaultChatTheme(
                      backgroundColor: K.lightPrimary,
                      inputBackgroundColor: K.lightSecondary,
                      secondaryColor: K.darkSecondary,
                      primaryColor: K.lightSecondary,
                      inputTextCursorColor: Colors.white,
                      inputTextColor: Colors.white,
                      messageBorderRadius: 12,
                    ),
            ),
          ),
          const NotificationWidget(),
        ],
      ),
    );
  }

  Future<void> destroy() async {
    _chatController.mySubscription.close();
    _chatController.theirSubscription.close();
    _notificationController.removeUser(
        userIDToRemove: _you.id,
        callback: _chatController.userController.chatStatusRead);
    _notificationController.currentChat = null;
  }
}
