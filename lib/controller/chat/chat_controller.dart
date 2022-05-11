import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypton/crypton.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/classes/custom_user.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

class ChatController extends GetxController {
  final String _partitionsKey = 'partitions';
  final String _dataKey = 'data';
  final int _maxMessagesPerPartition = 50;

  final CustomUser user1;
  final CustomUser user2;

  final Function setUIMessages;
  final Function addMessageToUI;
  final Function addMessagesAtEnd;

  late final RSAPublicKey theirPublicKey;
  late final RSAPublicKey myPublicKey;

  late String writeCollection;
  late String readCollection;

  List<String> myMessages = [];
  List<String> theirMessages = [];

  List<String> myPartitions = [];
  List<String> theirPartitions = [];

  late final RealtimeSubscription mySubscription;
  late final RealtimeSubscription theirSubscription;

  bool collectionExists = false;

  bool loadingMoreData = false;
  String? cursor;
  bool showingDescriptionError = false;

  ChatController({
    required this.user1,
    required this.user2,
    required this.setUIMessages,
    required this.addMessageToUI,
    required this.addMessagesAtEnd,
  });

  final UserController userController = Get.find(tag: K.userControllerTag);
  final DatabaseController _databaseController =
      Get.find(tag: K.databaseControllerTag);
  final EncryptionController _encryptionController =
      Get.find(tag: K.encryptionControllerTag);

  @override
  void onInit() async {
    super.onInit();

    theirPublicKey = RSAPublicKey.fromString(user2.publicKey!);
    myPublicKey =
        RSAPublicKey.fromString(userController.userData.value.publicKey!);

    readCollection = getCollectionID();
    writeCollection = getCollectionID(reverse: true);

    if (collectionFound(userID: user2.id)) {
      collectionExists = true;
    }

    if (collectionExists) {
      myPartitions = await getPartitions(collectionID: readCollection);
      cursor = myPartitions.last;
      theirPartitions = await getPartitions(collectionID: writeCollection);

      if (myPartitions.isNotEmpty) {
        myMessages = await getMessages(
            collectionID: readCollection, partition: myPartitions.last);
        setUIMessages(decryptMessages(
            messages: myMessages
                .map<types.TextMessage>(
                    (e) => types.TextMessage.fromJson(jsonDecode(e)))
                .toList()));
        if (myMessages.length < 10) {
          loadMoreMessages();
        }
      }
      if (theirPartitions.isNotEmpty) {
        theirMessages = await getMessages(
            collectionID: writeCollection, partition: theirPartitions.last);
      }
    }

    mySubscription =
        _databaseController.subscribeToChat(collectionID: readCollection);
    theirSubscription =
        _databaseController.subscribeToChat(collectionID: writeCollection);

    mySubscription.stream.listen((event) {
      if (event.event == 'database.documents.update') {
        final List<String> data =
            event.payload['data'].map<String>((e) => e.toString()).toList();
        if (data[0] == '1') {
          myPartitions = data;
        } else {
          if (myMessages.length < data.length) {
            myMessages = data;

            addMessageToUI(decryptMessage(
                message: types.TextMessage.fromJson(
              jsonDecode(myMessages.last),
            )));
            showingDescriptionError = false;
          }
        }
      }
    });

    theirSubscription.stream.listen((event) {
      if (event.event == 'database.documents.update') {
        final List<String> data =
            event.payload['data'].map<String>((e) => e.toString()).toList();
        if (data[0] == '1') {
          theirPartitions = data;
        } else {
          theirMessages = data;
        }
      }
    });
  }

  Future<void> addMessage({
    required types.TextMessage message,
    required Function afterMagic,
  }) async {
    final types.TextMessage theirMessage;
    final types.TextMessage myMessage;
    try {
      theirMessage = encryptMessage(
          message:
              message.copyWith(status: types.Status.sent) as types.TextMessage);
      myMessage = encryptMessage(
          message:
              message.copyWith(status: types.Status.sent) as types.TextMessage,
          mine: true);
    } catch (e) {
      K.showErrorToast(e);
      afterMagic(types.Status.error);
      return;
    }

    if (!collectionExists) {
      Execution? _execution = await _databaseController.createMessageCollection(
          user1: user1.id, user2: user2.id);
      if (_execution == null || _execution.status != 'completed') {
        afterMagic(types.Status.error);
        return;
      }
      myPartitions.add('1');
      theirPartitions.add('1');
      collectionExists = true;
      userController.addChatID(newID: user2.id);
    }

    await addMessageHelper(
      message: jsonEncode(theirMessage.toJson()),
      messages: theirMessages,
      collectionID: writeCollection,
      partitions: theirPartitions,
    ).then((theirValue) async {
      if (theirValue == null) {
        afterMagic(types.Status.error);
      } else {
        await addMessageHelper(
          message: jsonEncode(myMessage.toJson()),
          messages: myMessages,
          collectionID: readCollection,
          partitions: myPartitions,
        ).then((myValue) {
          if (myValue == null) {
            afterMagic(types.Status.error);
          } else {
            afterMagic(types.Status.sent);

            if (theirValue.length == 2) {
              theirPartitions = theirValue[1];
            }
            theirMessages = theirValue[0];

            if (myValue.length == 2) {
              myPartitions = myValue[1];
            }
            myMessages = myValue[0];

            _databaseController
                .notifyUser(user1: user1.id, user2: user2.id)
                .then((value) async {})
                .catchError(K.showErrorToast);
          }
        });
      }
    });
  }

  Future<List<dynamic>?> addMessageHelper({
    required String message,
    required List<String> messages,
    required String collectionID,
    required List<String> partitions,
  }) async {
    messages.add(message);

    if (await _databaseController.updateDocument(
            collectionID: collectionID,
            documentID: partitions.last,
            data: {
              _dataKey: messages,
            }) ==
        null) {
      return null;
    }

    if (messages.length == _maxMessagesPerPartition) {
      partitions.add((int.parse(partitions.last) + 1).toString());
      await _databaseController.createDocument(
          collectionID: collectionID,
          documentID: partitions.last,
          data: {
            _dataKey: [],
          });
      if (await _databaseController.updateDocument(
              collectionID: collectionID,
              documentID: _partitionsKey,
              data: {
                _dataKey: partitions,
              }) ==
          null) {
        return null;
      }
      return [messages, partitions];
    }

    return [messages];
  }

  bool collectionFound({required String userID}) {
    final List<String>? chatIDs = userController.userData.value.chatIDs;
    if (chatIDs == null || !chatIDs.contains(userID)) {
      return false;
    }
    return true;
  }

  String getCollectionID({bool reverse = false}) {
    if (reverse) {
      return '${user2.id.substring(user2.id.length - 16)}-${user1.id.substring(user1.id.length - 16)}';
    }
    return '${user1.id.substring(user1.id.length - 16)}-${user2.id.substring(user2.id.length - 16)}';
  }

  types.TextMessage encryptMessage({
    required types.TextMessage message,
    bool mine = false,
  }) {
    String encrypted = _encryptionController.encryptMessage(
        message: message.text, publicKey: mine ? myPublicKey : theirPublicKey);
    return message.copyWith(text: encrypted) as types.TextMessage;
  }

  types.TextMessage decryptMessage(
      {required types.TextMessage message, bool showToast = true}) {
    String? decrypted;
    try {
      decrypted =
          _encryptionController.decryptMessage(encryptedMessage: message.text);
    } catch (e) {}
    if (decrypted != null) {
      return message.copyWith(text: decrypted) as types.TextMessage;
    }
    if (!showingDescriptionError) {
      K.showToast(message: 'Unable to Decrypt messages');
      showingDescriptionError = true;
    }
    return message;
  }

  List<types.TextMessage> decryptMessages(
      {required List<types.TextMessage> messages}) {
    List<types.TextMessage> temp = messages
        .map<types.TextMessage>((e) => decryptMessage(message: e))
        .toList();
    showingDescriptionError = false;
    return temp;
  }

  Future<List<String>> getPartitions({required String collectionID}) async {
    Document? document = await _databaseController.getDocument(
        collectionID: collectionID, documentID: _partitionsKey);
    if (document != null) {
      return document.data[_dataKey].map<String>((e) => e.toString()).toList();
    }
    return [];
  }

  Future<List<String>> getMessages(
      {required String collectionID, required String partition}) async {
    Document? document = await _databaseController.getDocument(
        collectionID: collectionID, documentID: partition);
    if (document != null) {
      if (document.data[_dataKey] != null) {
        return document.data[_dataKey]
            .map<String>((e) => e.toString())
            .toList();
      }
    }

    return [];
  }

  int getPreviousCursor() {
    if (cursor != null) {
      return int.parse(cursor!) - 1;
    }
    return 0;
  }

  void loadMoreMessages() async {
    if (loadingMoreData) {
      return;
    }
    if (cursor == '1') {
      return;
    }
    loadingMoreData = true;
    int previous = getPreviousCursor();
    if (previous > 0) {
      final List<String> newMessages = await getMessages(
          collectionID: readCollection, partition: previous.toString());
      addMessagesAtEnd(decryptMessages(
          messages: newMessages.reversed
              .map<types.TextMessage>(
                  (e) => types.TextMessage.fromJson(jsonDecode(e)))
              .toList()));
      cursor = previous.toString();
    }
    loadingMoreData = false;
  }

  @override
  void dispose() {
    try {
      theirSubscription.stream.listen((event) {});
      mySubscription.stream.listen((event) {});
    } catch (e) {}
    super.dispose();
  }
}
