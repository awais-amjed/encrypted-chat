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

    setEndPoint(endPoint: 'http://192.168.100.2/v1');
    setProjectID(id: 'yolo');

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

  void setProjectID({required String id}) {
    client.setProject(id);
  }

  void setEndPoint({required String endPoint}) {
    client.setEndpoint(endPoint);
  }
}
