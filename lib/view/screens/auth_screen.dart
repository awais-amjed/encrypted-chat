import 'package:ecat/controller/auth/auth_controller.dart';
import 'package:ecat/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.put(AuthController());
    return Scaffold(
      body: FlutterLogin(
        title: 'E Cat',
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
          Get.to(() => HomeScreen());
        },
        messages: LoginMessages(
          additionalSignUpFormDescription: 'Please Enter your name',
          signUpSuccess: 'Account Created Successfully!',
        ),
        additionalSignupFields: const [
          UserFormField(
            keyName: 'full_name',
            icon: Icon(Icons.person),
            displayName: 'Full Name',
          ),
        ],
        hideForgotPasswordButton: true,
        onRecoverPassword: (_) {},
        savedEmail: 'meow@gmail.com',
        savedPassword: 'meow86602',
      ),
    );
  }
}
