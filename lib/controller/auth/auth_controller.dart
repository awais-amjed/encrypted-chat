import 'package:appwrite/appwrite.dart';
import 'package:ecat/controller/app_write_controller.dart';
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
  }) async {
    String? error;
    await account
        .createSession(
      email: email,
      password: password,
    )
        .then((session) {
      UserController _ = Get.put(
        UserController(currentSession: session),
        tag: K.userControllerTag,
        permanent: true,
      );
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }
}
