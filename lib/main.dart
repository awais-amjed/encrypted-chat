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

  runApp(const ECat());
}

class ECat extends StatelessWidget {
  const ECat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController _themeController = Get.put(
      ThemeController(),
      tag: K.themeControllerTag,
      permanent: true,
    );

    return Sizer(builder: (context, orientation, deviceType) {
      return DismissKeyboardOnTap(
        child: GetMaterialApp(
          theme: ThemeData(
            splashColor: Colors.white12,
            scaffoldBackgroundColor: K.whiteText,
            listTileTheme: const ListTileThemeData(
              iconColor: K.blackText,
            ),
            colorScheme: const ColorScheme.light(
              primary: K.lightSecondary,
              secondary: K.lightSecondary,
              tertiary: K.lightPrimary,
              onSecondary: K.lightPrimary,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              prefixIconColor: Colors.black,
              suffixIconColor: Colors.black,
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: K.whiteText),
              headline6: TextStyle(color: K.whiteText),
              bodyText2: TextStyle(color: K.blackText), // text
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: K.lightSecondary,
                secondary: K.lightSecondary,
              ),
              buttonColor: K.lightSecondary,
            ),
          ),
          darkTheme: ThemeData(
            splashColor: Colors.white12,
            scaffoldBackgroundColor: K.darkPrimary,
            listTileTheme: const ListTileThemeData(
              iconColor: K.whiteText,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              prefixIconColor: Colors.black,
              suffixIconColor: Colors.black,
            ),
            appBarTheme: const AppBarTheme(
              color: K.darkAppbar,
            ),
            colorScheme: const ColorScheme.dark(
              primary: K.darkSecondary,
              secondary: K.darkSecondary,
              tertiary: K.darkPrimary,
              onSecondary: K.darkPrimary,
              onPrimary: K.darkPrimary,
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: K.whiteText),
              headline6: TextStyle(color: K.whiteText),
              bodyText2: TextStyle(color: K.whiteText), // text
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.dark(
                background: K.darkPrimary,
              ),
            ),
          ),
          themeMode: _themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const AuthScreen(),
        ),
      );
    });
  }
}
