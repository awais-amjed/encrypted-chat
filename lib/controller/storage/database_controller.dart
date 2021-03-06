import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  late Database _database;
  Session session;
  late Functions _functions;
  late Realtime _realtime;

  // keys
  final String _usersCollectionKey = 'users'; // this is also used during auth
  final String _publicKey = 'public_key';
  final String _createMessageCollectionFunctionKey = 'createMessageCollection';
  final String _notifyUserFunctionKey = 'notifyUser';

  DatabaseController({required this.session});

  final AppWriteController _appWriteController =
      Get.find(tag: K.appWriteControllerTag);

  void initialize({required Session newSession}) {
    session = newSession;
    _database = _appWriteController.database;
    _functions = Functions(_appWriteController.client);
    _realtime = Realtime(_appWriteController.client);

    subscribeToNotifications();
  }

  Future<bool?> isPublicKeyAvailable() async {
    bool? result;
    await _database
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
    return _database.updateDocument(
      collectionId: _usersCollectionKey,
      documentId: session.userId,
      data: {
        _publicKey: publicKey,
      },
    );
  }

  Future<DocumentList?> getAllUsers() async {
    DocumentList? documents;
    await _database.listDocuments(
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
    await _database
        .getDocument(
      collectionId: _usersCollectionKey,
      documentId: userID,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }

  Future<Document> updateUserData({
    required Map<dynamic, dynamic> data,
  }) {
    return _database.updateDocument(
      collectionId: _usersCollectionKey,
      documentId: session.userId,
      data: data,
    );
  }

  Future<Execution?> createMessageCollection(
      {required String user1, required String user2}) async {
    Execution? execution;
    await _functions
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
    await _database
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
    await _database
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
    await _database
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
    _functions.createExecution(
      functionId: _notifyUserFunctionKey,
      data: '$user1-$user2'.toString(),
      xasync: false,
    );
  }

  RealtimeSubscription subscribeToNotifications() {
    return _realtime
        .subscribe(['collections.notifications.documents.${session.userId}']);
  }

  RealtimeSubscription subscribeToChat({required String collectionID}) {
    return _realtime.subscribe(['collections.$collectionID.documents']);
  }

  Future logOut() async {
    Account account = Account(_appWriteController.client);
    return account.deleteSession(sessionId: session.$id);
  }

  Future updatePassword(
      {required String oldPassword, required String newPassword}) async {
    Account _account = Account(_appWriteController.client);
    return await _account.updatePassword(
        password: newPassword, oldPassword: oldPassword);
  }
}
