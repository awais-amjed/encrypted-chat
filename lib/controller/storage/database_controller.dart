import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  late Database database;
  final Session session;
  late Functions functions;

  // keys
  final String _usersCollectionKey = 'users'; // this is also used during auth
  final String _publicKey = 'public_key';
  final String _createMessageCollectionFunctionKey = 'createMessageCollection';
  final String _notifyUserFunctionKey = 'notifyUser';

  DatabaseController({required this.session});

  @override
  void onInit() {
    super.onInit();

    AppWriteController _ = Get.find(tag: K.appWriteControllerTag);
    database = _.database;
    functions = Functions(_.client);
  }

  Future<bool?> isPublicKeyAvailable() async {
    bool? result;
    await database
        .getDocument(
      collectionId: _usersCollectionKey,
      documentId: session.userId,
    )
        .then((value) {
      if (value.data[_publicKey] != null) {
        result = true;
      } else {
        result = false;
      }
    }).catchError(K.showErrorToast);

    return result;
  }

  Future updatePublicKey({
    required String publicKey,
  }) {
    return database.updateDocument(
      collectionId: _usersCollectionKey,
      documentId: session.userId,
      data: {
        _publicKey: publicKey,
      },
    );
  }

  Future<DocumentList?> getAllUsers() async {
    DocumentList? documents;
    await database.listDocuments(
      collectionId: _usersCollectionKey,
      orderAttributes: ['name'],
      orderTypes: ['ASC'],
    ).then((value) {
      documents = value;
    }).catchError(K.showErrorToast);
    return documents;
  }

  Future<Document?> getUser({required String userID}) async {
    Document? document;
    await database
        .getDocument(
      collectionId: _usersCollectionKey,
      documentId: userID,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }

  Future updateUserData({
    required Map<dynamic, dynamic> data,
  }) {
    return database.updateDocument(
      collectionId: _usersCollectionKey,
      documentId: session.userId,
      data: data,
    );
  }

  Future<Execution?> createMessageCollection(
      {required String user1, required String user2}) async {
    Execution? execution;
    await functions
        .createExecution(
      functionId: _createMessageCollectionFunctionKey,
      data: '$user1-$user2'.toString(),
      xasync: false,
    )
        .then((value) {
      execution = value;
    }).catchError(K.showErrorToast);
    return execution;
  }

  Future<Document?> getDocument({
    required String collectionID,
    required String documentID,
  }) async {
    Document? document;
    await database
        .getDocument(
      collectionId: collectionID,
      documentId: documentID,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }

  Future<Document?> createDocument({
    required String collectionID,
    required String documentID,
    required Map<dynamic, dynamic> data,
  }) async {
    Document? document;
    await database
        .createDocument(
      collectionId: collectionID,
      documentId: documentID,
      data: data,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }

  Future<Document?> updateDocument({
    required String collectionID,
    required String documentID,
    required Map<dynamic, dynamic> data,
  }) async {
    Document? document;
    await database
        .updateDocument(
      collectionId: collectionID,
      documentId: documentID,
      data: data,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }

  Future notifyUser({required String user1, required String user2}) async {
    functions.createExecution(
      functionId: _notifyUserFunctionKey,
      data: '$user1-$user2'.toString(),
      xasync: false,
    );
  }
}
