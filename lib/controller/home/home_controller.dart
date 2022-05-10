import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final UserController _userController = Get.find(tag: K.userControllerTag);

  @override
  void onInit() {
    super.onInit();
  }
}
