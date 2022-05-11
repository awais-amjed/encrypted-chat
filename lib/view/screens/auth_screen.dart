import 'package:ecat/controller/auth/auth_controller.dart';
import 'package:ecat/controller/home/home_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/appwrite_setup.dart';
import 'package:ecat/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/theme_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController _themeController = Get.find(tag: K.themeControllerTag);
    final AuthController _authController = Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterLogin(
              scrollable: true,
              footer: "YES, IT'S CUTE AND SECURE",
              theme: LoginTheme(
                bodyStyle: const TextStyle(color: K.blackText),
                titleStyle: const TextStyle(
                  height: 1.5,
                  color: K.whiteText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textFieldStyle: const TextStyle(color: K.blackText),
                buttonStyle: const TextStyle(color: K.whiteText),
                switchAuthTextColor: K.blackText,
                primaryColor: _themeController.isDarkMode.value
                    ? K.darkPrimary
                    : K.lightSecondary,
                accentColor: K.whiteText,
                authButtonPadding: const EdgeInsets.symmetric(vertical: 20),
                cardTheme: CardTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 8.h),
                ),
                footerBottomPadding: 20,
                footerTextStyle: const TextStyle(
                  color: K.whiteText,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                inputTheme: InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: InputBorder.none,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                buttonTheme: LoginButtonTheme(
                  backgroundColor: _themeController.isDarkMode.value
                      ? K.darkPrimary
                      : K.lightSecondary,
                  highlightColor: Colors.white10,
                  splashColor: Colors.white10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              initialAuthMode: AuthMode.signup,
              title: 'ENCRYPTED CHAT',
              logo: const AssetImage('assets/images/logo.png'),
              onLogin: (data) async {
                return await _authController.signIn(
                  email: data.name,
                  password: data.password,
                );
              },
              onSignup: (data) async {
                if (data.name == null ||
                    data.password == null ||
                    data.additionalSignupData == null ||
                    data.additionalSignupData!['full_name'] == null) {
                  return 'Fill in the details first';
                }

                return await _authController.signUp(
                  email: data.name!,
                  password: data.password!,
                  name: data.additionalSignupData!['full_name']!,
                );
              },
              loginAfterSignUp: false,
              onSubmitAnimationCompleted: () {
                Get.put<HomeController>(HomeController());
                Get.off(() => const HomeScreen());
              },
              messages: LoginMessages(
                additionalSignUpFormDescription: 'Please Enter your name',
                signUpSuccess: 'Account Created Successfully!',
              ),
              additionalSignupFields: [
                UserFormField(
                  keyName: 'full_name',
                  icon: const Icon(Icons.person),
                  displayName: 'Full Name',
                  fieldValidator: (_) {
                    return _ == null || _.trim() == ''
                        ? "Can't be empty"
                        : null;
                  },
                ),
              ],
              hideForgotPasswordButton: true,
              onRecoverPassword: (_) {
                return null;
              },
              savedEmail: 'meow@gmail.com',
              savedPassword: 'meow86602',
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: IconButton(
                iconSize: 25,
                color: Colors.white,
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {
                  Get.to(() => const AppWriteSetup(allowDarkMode: true));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
