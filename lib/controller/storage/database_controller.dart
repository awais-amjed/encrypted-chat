import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  late Database database;
  final Session session;

  // keys
  final String _usersCollection = 'users'; // this is also used during auth
  final String _publicKey = 'public_key';
  final String usersCollection = 'users';

  DatabaseController({required this.session});

  @override
  void onInit() {
    super.onInit();

    AppWriteController _ = Get.find(tag: K.appWriteControllerTag);
    database = _.database;
  }

  Future<bool?> isPublicKeyAvailable() async {
    bool? result;
    await database
        .getDocument(
      collectionId: _usersCollection,
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
      collectionId: _usersCollection,
      documentId: session.userId,
      data: {
        _publicKey: publicKey,
      },
    );
  }

  Future<DocumentList?> getAllUsers() async {
    DocumentList? documents;
    await database.listDocuments(
      collectionId: usersCollection,
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
      collectionId: 'users',
      documentId: userID,
    )
        .then((value) {
      document = value;
    }).catchError(K.showErrorToast);
    return document;
  }
}
