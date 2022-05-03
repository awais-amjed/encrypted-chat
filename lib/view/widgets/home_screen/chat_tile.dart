import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/CustomNetworkImage.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    this.imageURL,
    required this.userName,
    required this.lastMessage,
    required this.dateTime,
  }) : super(key: key);

  final String? imageURL;
  final String userName;
  final String lastMessage;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ClipOval(
              child: CustomNetworkImage(
                url:
                    'https://media.istockphoto.com/photos/picking-the-right-paint-paint-sample-color-swatch-picture-id92241441?b=1&k=20&m=92241441&s=170667a&w=0&h=OudUCphkJO9Gx9AdVpYIIypg48ELx72Zd46W818fTa8=',
                fit: BoxFit.cover,
                height: 65,
                width: 65,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: Text(
              HelperFunctions.getDateOrTime(dateTime: dateTime),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
