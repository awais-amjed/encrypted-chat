import 'package:dismiss_keyboard_on_tap/dismiss_keyboard_on_tap.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(ECat());
}

class ECat extends StatelessWidget {
  ECat({Key? key}) : super(key: key);

  final AppWriteController _ = Get.put(
    AppWriteController(),
    tag: K.appWriteControllerTag,
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return DismissKeyboardOnTap(
        child: GetMaterialApp(
          home: AuthScreen(),
        ),
      );
    });
  }
}
