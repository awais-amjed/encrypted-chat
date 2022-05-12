import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/appwrite_setup.dart';
import 'package:ecat/view/screens/qr_code.dart';
import 'package:ecat/view/screens/your_space.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:ecat/view/widgets/general/theme_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/home/home_controller.dart';
import '../../../controller/notification/notification_controller.dart';
import '../../screens/auth_screen.dart';

class DrawerScreen extends GetView<HomeController> {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find(tag: K.userControllerTag);
    RxBool loggingOut = false.obs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.h, 0, 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => Center(
                  child: AvatarWidget(
                    size: 80,
                    image: _userController.userData.value.imagePath,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(
                () => Text(
                  _userController.userData.value.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Expanded(
                child: ListView(
                  children: [
                    _HelperListTile(
                      text: 'Your space',
                      imageURL: 'assets/icons/programmer.png',
                      onTap: () {
                        Get.to(() => const YourSpace());
                      },
                    ),
                    _HelperListTile(
                      text: 'Private Key',
                      imageURL: 'assets/icons/private-access.png',
                      onTap: () {
                        Get.to(() => const QRCode());
                      },
                    ),
                    _HelperListTile(
                      text: 'Update Backend',
                      imageURL: 'assets/icons/cloud-server.png',
                      onTap: () {
                        Get.to(() => const AppWriteSetup());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              const Align(
                alignment: Alignment.centerLeft,
                child: ThemeSwitchButton(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      loggingOut.value = true;
                      bool? result = await K.showDialog(
                        context: context,
                        title: 'Save your private Key first!',
                        content:
                            'Make sure to make a backup of your private key. If you login with another account, '
                            'your key might get overwritten and you will loose all your data',
                        cancelText: 'Already have a backup',
                        confirmText: 'Take me to private key',
                        onConfirm: () {
                          return true;
                        },
                        onCancel: () {
                          return false;
                        },
                      );
                      if (result == false) {
                        await _userController.logOut().then((value) async {
                          final NotificationController _notificationController =
                              Get.find(tag: K.notificationControllerTag);
                          await _notificationController.notificationSubscription
                              .close();
                          Get.offAll(() => const AuthScreen());
                        }).catchError(K.showErrorToast);
                      } else if (result == true) {
                        Get.to(() => const QRCode());
                      }
                      loggingOut.value = false;
                    },
                    child: loggingOut.value
                        ? const CircularProgressIndicator()
                        : const Text('Log out'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelperListTile extends StatelessWidget {
  const _HelperListTile(
      {Key? key, required this.text, required this.imageURL, this.onTap})
      : super(key: key);

  final String text;
  final String imageURL;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imageURL,
        height: 30,
      ),
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
