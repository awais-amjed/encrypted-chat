import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.selectedUser, this.documentID})
      : super(key: key);

  final CustomUser selectedUser;
  final String? documentID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  late types.User _me;
  late types.User _you;

  @override
  void initState() {
    super.initState();

    _you = types.User(
      id: widget.selectedUser.id,
      firstName: widget.selectedUser.name,
      imageUrl: widget.selectedUser.imageURL,
    );

    UserController _userController = Get.find(tag: K.userControllerTag);
    print(_userController.currentSession.toMap());
    // _me = types.User(
    //   id: _userController.currentSession.userId,
    //   firstName: _userController.currentSession.clientName,
    // )
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    print(_messages);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _you,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        user: _you,
        onSendPressed: _handleSendPressed,
        messages: _messages,
      ),
    );
  }
}