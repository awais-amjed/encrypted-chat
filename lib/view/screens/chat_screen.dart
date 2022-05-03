import 'package:ecat/model/classes/custom_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
  late types.User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _user = types.User(
      id: widget.selectedUser.id,
      firstName: widget.selectedUser.name,
      imageUrl: widget.selectedUser.imageURL,
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    print(_messages);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        user: _user,
        onSendPressed: _handleSendPressed,
        messages: _messages,
      ),
    );
  }
}
