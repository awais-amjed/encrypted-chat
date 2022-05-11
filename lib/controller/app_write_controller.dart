import 'package:appwrite/appwrite.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class AppWriteController extends GetxController {
  Client client = Client();
  late Database database;

  @override
  void onInit() {
    super.onInit();
    client.setSelfSigned(status: true);

    client.setEndpoint('http://192.168.100.2/v1');
    client.setProject('yolo');

    database = Database(client);

    Get.put(
      LocalStorageController(),
      tag: K.localStorageControllerTag,
    );
    Get.put(
      EncryptionController(),
      tag: K.encryptionControllerTag,
    );
  }

  void updateParams({required String id, required String endPoint}) {
    client.setProject(id);
    client.setEndpoint(endPoint);
    database = Database(client);
  }
}
