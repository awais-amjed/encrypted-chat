import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/screens/appwrite_setup.dart';
import 'package:ecat/view/screens/qr_code.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:ecat/view/widgets/general/theme_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/home/home_controller.dart';

class DrawerScreen extends GetView<HomeController> {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find(tag: K.userControllerTag);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.h, 0, 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: AvatarWidget(size: 80)),
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
                      icon: Icons.account_circle,
                    ),
                    _HelperListTile(
                      text: 'Private Key',
                      icon: Icons.key,
                      onTap: () {
                        Get.to(() => const QRCode());
                      },
                    ),
                    _HelperListTile(
                      text: 'Update Backend',
                      icon: Icons.storage,
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
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Log out'),
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
      {Key? key, required this.text, required this.icon, this.onTap})
      : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
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
