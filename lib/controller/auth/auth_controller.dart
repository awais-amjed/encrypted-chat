import 'package:appwrite/appwrite.dart';
import 'package:crypton/crypton.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/controller/storage/database_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';

import '../../view/screens/qr_code.dart';

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
        .then((value) => null)
        .catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<String?>? signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Create a session
    String? error;
    await account
        .createSession(
      email: email,
      password: password,
    )
        .then((session) async {
      final UserController _userController = Get.put(
        UserController(currentSession: session),
        tag: K.userControllerTag,
      );

      await _userController.initialize(session: session);

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

        LocalStorageController _localStorageController =
            Get.find(tag: K.localStorageControllerTag);
        await _databaseController
            .updatePublicKey(publicKey: keypair.publicKey.toString())
            .then((value) async {
          _userController.userData.value.publicKey =
              keypair.publicKey.toString();
        }).catchError(
          (e) {
            error = e.toString();
          },
        );

        if (error == null) {
          _localStorageController.savePrivateKey(
              privateKey: keypair.privateKey.toString());
        }
      }
      if (isKeyFound == true) {
        // If public key is found
        final EncryptionController _encryptionController =
            Get.find(tag: K.encryptionControllerTag);
        _encryptionController.readPrivateKey();

        await showAnimatedDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text(
                'Hmmm ...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              contentPadding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Text(
                    'Seems like you have logged in with this account somewhere before. If you logged in on this device '
                    "then probably your private key is still here. But if you are switching a device "
                    "then you will need a private key. Would you like to import private key or create a new one? (creating a new one will "
                    "result in not being able to read your previous messages)",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'I think my key is already saved on this device',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final EncryptionController _encryptionController =
                        Get.find(tag: K.encryptionControllerTag);
                    RSAKeypair keypair =
                        _encryptionController.generateNewKeys();

                    final LocalStorageController _localStorageController =
                        Get.find(tag: K.localStorageControllerTag);
                    final DatabaseController _databaseController =
                        Get.find(tag: K.databaseControllerTag);
                    final UserController _userController =
                        Get.find(tag: K.userControllerTag);

                    await _databaseController
                        .updatePublicKey(
                            publicKey: keypair.publicKey.toString())
                        .then((value) async {
                      _userController.userData.value.publicKey =
                          keypair.publicKey.toString();
                      _localStorageController.savePrivateKey(
                          privateKey: keypair.privateKey.toString());
                      K.showToast(message: 'Generated new key successfully');
                    }).catchError(K.showErrorToast);
                  },
                  child: const Text(
                    'I would like to generate a new one (caution! not Recommended at all)',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() => const QRCode());
                  },
                  child: Text(
                    'I would like to import the key from a saved screenshot',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    K.showToast(message: 'K! your funeral');
                  },
                  child: Text(
                    'Oh I am the all knowing let me pass!',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ),
              ],
            );
          },
          animationType: DialogTransitionType.scale,
          duration: const Duration(milliseconds: 300),
        );
      }
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }
}
