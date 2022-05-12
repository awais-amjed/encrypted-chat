import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:appwrite/models.dart';
import 'package:ecat/controller/storage/local_storage_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/auth_screen.dart';
import 'package:ecat/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home/home_controller.dart';
import '../../controller/user_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void checkSession() async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      final LocalStorageController _localStorageController =
          Get.find(tag: K.localStorageControllerTag);
      Session? session = _localStorageController.getSession();
      if (session == null) {
        Get.off(() => const AuthScreen());
      } else {
        final UserController _userController = Get.put(
          UserController(currentSession: session),
          tag: K.userControllerTag,
        );
        await _userController.initialize(session: session);
        Get.put<HomeController>(HomeController());
        Get.off(() => const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkSession();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Bounce(
              infinite: true,
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 200,
              child: AnimatedTextKit(
                repeatForever: false,
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Encrypted Chat',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
