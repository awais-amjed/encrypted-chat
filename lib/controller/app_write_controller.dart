import 'package:appwrite/appwrite.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../view/screens/auth_screen.dart';
import '../view/screens/qr_code.dart';
import 'notification/notification_controller.dart';

class AppWriteController extends GetxController {
  Client client = Client();
  late Database database;

  @override
  void onInit() {
    super.onInit();
    // client.setSelfSigned(status: true);

    client.setEndpoint(
        'https://8080-appwrite-integrationfor-o1wbqfvan8m.ws-eu44.gitpod.io/v1');
    client.setProject('yolo');

    database = Database(client);

    Get.put(
      LocalStorageController(),
      tag: K.localStorageControllerTag,
      permanent: true,
    );
    Get.put(
      EncryptionController(),
      tag: K.encryptionControllerTag,
      permanent: true,
    );
  }

  Future<void> updateParams({
    required String id,
    required String endPoint,
    bool logout = true,
    BuildContext? context,
  }) async {
    if (logout && context != null) {
      bool? result = await K.showDialog(
        context: context,
        title: 'Save your private Key first!',
        content:
            'Make sure to make a backup of your private key. If you login with another account, '
            'your key might get overwritten and you will loose all your data',
        cancelText: 'Already have a backup',
        confirmText: 'Take me to private key',
        onConfirm: () {
          return true;
        },
        onCancel: () {
          return false;
        },
      );
      if (result == false) {
        final UserController _userController =
            Get.find(tag: K.userControllerTag);
        await _userController.logOut().then((value) async {
          final NotificationController _notificationController =
              Get.find(tag: K.notificationControllerTag);
          await _notificationController.notificationSubscription.close();
          final LocalStorageController _local =
              Get.find(tag: K.localStorageControllerTag);
          _local.deleteSession();
          Get.offAll(() => const AuthScreen());
        }).catchError(K.showErrorToast);
      } else if (result == true) {
        Get.to(() => const QRCode());
      }
    } else {
      K.showToast(message: 'Successfully changed server');
      Get.back();
    }

    client.setProject(id);
    client.setEndpoint(endPoint);
    database = Database(client);
  }
}
