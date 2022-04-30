import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

class AppWriteController extends GetxController {
  Client client = Client();

  @override
  void onInit() {
    super.onInit();
    client.setSelfSigned(status: true);

    setEndPoint(endPoint: 'http://192.168.100.2/v1');
    setProjectID(id: 'ecat');
  }

  void setProjectID({required String id}) {
    client.setProject(id);
  }

  void setEndPoint({required String endPoint}) {
    client.setEndpoint(endPoint);
  }
}
