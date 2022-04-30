import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

class K {
  // Colors
  // TODO Colors to be decided

  // Frequently used variables
  GetStorage localStorage = GetStorage();

  // Controller tags
  static const String appWriteControllerTag = 'appWriteControllerTag';
  static const String userControllerTag = 'userControllerTag';

  // Functions
  static void showToast({required String message, Toast? toastLength}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
