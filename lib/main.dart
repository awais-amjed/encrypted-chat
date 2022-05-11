import 'package:dismiss_keyboard_on_tap/dismiss_keyboard_on_tap.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(
    AppWriteController(),
    tag: K.appWriteControllerTag,
    permanent: true,
  );

  Get.put(
    ThemeController(),
    tag: K.themeControllerTag,
    permanent: true,
  );

  runApp(const ECat());
}

class ECat extends StatelessWidget {
  const ECat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return DismissKeyboardOnTap(
        child: GetMaterialApp(
          // theme: ThemeData(
          //   brightness: Brightness.light,
          //   primaryColor: K.lightSecondary,
          //   colorScheme: const ColorScheme.light(
          //     primary: K.lightSecondary,
          //     secondary: K.lightSecondary,
          //     background: K.lightPrimary,
          //     tertiary: K.lightSecondary,
          //   ),
          //   buttonTheme: const ButtonThemeData(
          //     colorScheme: ColorScheme.light(
          //       primary: K.lightSecondary,
          //       secondary: K.lightSecondary,
          //     ),
          //     buttonColor: K.lightSecondary,
          //   ),
          // ),
          home: const AuthScreen(),
        ),
      );
    });
  }
}
