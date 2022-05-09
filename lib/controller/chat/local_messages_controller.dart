import 'package:ecat/model/classes/message_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalMessagesController extends GetxController {
  // Controls the local messages persistence

  final String collectionID;

  LocalMessagesController({required this.collectionID});

  late final GetStorage messageBox;
  late final List<String> partitions;

  late final List<MessageModel> messages;
  late int currentPointer;

  @override
  void onInit() {
    super.onInit();

    messageBox = GetStorage(collectionID);
    List<String>? tempPartitions = messageBox.read('partitions');
    if (tempPartitions != null) {
      partitions = tempPartitions;
      currentPointer = partitions.length - 1;

      List<MessageModel>? tempMessages =
          messageBox.read(partitions.elementAt(currentPointer));
      if (tempMessages != null) {
        messages = tempMessages;
      } else {
        messages = [];
      }
    } else {
      partitions = ['0'];
      currentPointer = 0;
      messages = [];
    }
  }

  List<MessageModel> getMessages() {
    List<MessageModel> result = messages;
    if (result.length < 50) {
      currentPointer -= 1;
      result.addAll(messageBox.read(partitions.elementAt(currentPointer)));
    }
    return result;
  }

  Future<void> saveMessages() async {
    await messageBox.write('partitions', partitions);
    await messageBox.write(partitions.last, messages);
  }

  void addMessage({required MessageModel message}) async {
    if (messages.length < 500) {
      messages.add(message);
    } else {
      await saveMessages();
      partitions.add((int.parse(partitions.last) + 1).toString());
      messages.clear();
      messages.add(message);
    }
  }

  List<MessageModel>? readMoreMessages() {
    if (currentPointer > 1) {
      currentPointer -= 1;
      return messageBox.read(partitions.elementAt(currentPointer));
    }
    return null;
  }
}
