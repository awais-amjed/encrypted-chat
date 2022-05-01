import 'package:crypton/crypton.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

import '../storage/local_storage_controller.dart';

class EncryptionController extends GetxController {
  RSAPrivateKey? privateKey;

  final LocalStorageController _localStorageController =
      Get.find(tag: K.localStorageControllerTag);

  @override
  void onInit() {
    super.onInit();

    String? storedPrivateKey = _localStorageController.readPrivateKey();

    if (storedPrivateKey != null) {
      privateKey = RSAPrivateKey.fromString(storedPrivateKey);
    }
  }

  String encryptMessage({
    required String message,
    required RSAPublicKey publicKey,
  }) {
    return publicKey.encrypt(message);
  }

  String? decryptMessage({required String encryptedMessage}) {
    if (privateKey != null) {
      return privateKey?.decrypt(encryptedMessage);
    } else {
      return null;
    }
  }

  RSAKeypair generateNewKeys() {
    return RSAKeypair.fromRandom();
  }
}
