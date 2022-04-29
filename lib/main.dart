import 'package:dismiss_keyboard_on_tap/dismiss_keyboard_on_tap.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';

import './view/screens/home_screen.dart';

void main() {
  runApp(const ECat());
}

class ECat extends StatelessWidget {
  const ECat({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return DismissKeyboardOnTap(
        child: const GetMaterialApp(
          home: HomeScreen(),
        ),
      );
    });
  }
}
