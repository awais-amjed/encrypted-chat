import 'package:ecat/view/widgets/home_screen/chat_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Encrypted Chat',
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2015, 9, 15),
          ),
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2022, 1, 15),
          ),
          ChatTile(
            userName: 'userName',
            lastMessage: 'lastMessage',
            dateTime: DateTime(2022, 5, 3, 19, 51),
          ),
        ],
      ),
    );
  }
}
