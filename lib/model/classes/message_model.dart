import 'package:appwrite/models.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageModel {
  static const String lastUpdatedKey = 'last_updated';
  static const String partitionsKey = 'partitions';

  DateTime? lastUpdated;
  List<String>? partitions;
  Map<String, types.TextMessage>? messages;

  MessageModel({
    this.lastUpdated,
    this.partitions,
    this.messages,
  });

  void populateData({required DocumentList documentList}) {
    String? date = documentList.documents
        .firstWhere((element) => element.$id == lastUpdatedKey)
        .data['data']?[0];
    if (date != null) {
      lastUpdated = DateTime.parse(date);
    }

    partitions = documentList.documents
        .firstWhere((element) => element.$id == partitionsKey)
        .data['data']
        ?.map<String>((e) => e.toString())
        .toList();

    if (partitions != null) {
      messages = documentList.documents
          .firstWhere((element) => element.$id == partitionsKey)
          .data['data']
          ?.map<String>((e) => e.toString())
          .toList();
    }
  }
}
