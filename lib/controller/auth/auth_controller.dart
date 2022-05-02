import 'package:appwrite/appwrite.dart';
import 'package:crypton/crypton.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AppWriteController _appWriteController =
      Get.find(tag: K.appWriteControllerTag);
  late Account account;

  @override
  void onInit() {
    super.onInit();
    account = Account(_appWriteController.client);
  }

  Future<String?>? signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Create new account
    String? error;
    await account
        .create(
      userId: 'unique()',
      email: email,
      password: password,
      name: name,
    )
        .then((value) {
      _appWriteController.database.createDocument(
        collectionId: 'users',
        documentId: value.$id,
        data: {
          'name': name,
        },
        read: ['role:all'],
      );
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<String?>? signIn({
    required String email,
    required String password,
  }) async {
    // Create a session
    String? error;
    await account
        .createSession(
      email: email,
      password: password,
    )
        .then((session) async {
      Get.put(
        UserController(currentSession: session),
        tag: K.userControllerTag,
        permanent: true,
      );

      //Check for Public Key
      DatabaseController _databaseController =
          Get.find(tag: K.databaseControllerTag);
      final bool? isKeyFound = await _databaseController.isPublicKeyAvailable();
      if (isKeyFound == null) {
        error = 'Database Error';
      }
      if (isKeyFound == false) {
        // If not found create new key pair
        EncryptionController _encryptionController =
            Get.find(tag: K.encryptionControllerTag);
        RSAKeypair keypair = _encryptionController.generateNewKeys();

        LocalStorageController _localStorageControllerTag =
            Get.find(tag: K.localStorageControllerTag);
        await _databaseController
            .updatePublicKey(publicKey: keypair.publicKey.toString())
            .then((value) => null)
            .catchError(
          (e) {
            error = e.toString();
          },
        );

        if (error == null) {
          _localStorageControllerTag.savePrivateKey(
              privateKey: keypair.privateKey.toString());
        }
      }
      if (isKeyFound == true) {
        // If public key is found
        //TODO Implement key sharing
      }
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }
}
