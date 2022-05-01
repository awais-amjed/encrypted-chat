import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  GetStorage localStorage = GetStorage();

  final String _privateKeyHolder = 'privateKey';

  String? readPrivateKey() {
    return localStorage.read(_privateKeyHolder);
  }

  void savePrivateKey({required String privateKey}) async {
    await localStorage.write(_privateKeyHolder, privateKey);
  }
}
