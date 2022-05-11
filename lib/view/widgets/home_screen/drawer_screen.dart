import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
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
    RxBool toggle = false.obs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.h, 0, 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AvatarWidget(size: 80),
              const SizedBox(height: 20),
              Obx(
                () => Text(
                  _userController.userData.value.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: const [
                    _HelperListTile(
                      text: 'Your space',
                      icon: Icons.account_circle,
                    ),
                    _HelperListTile(
                      text: 'Private Key',
                      icon: Icons.key,
                    ),
                    _HelperListTile(
                      text: 'Update Backend Parameters',
                      icon: Icons.storage,
                    ),
                  ],
                ),
              ),
              const ThemeSwitchButton(),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 45.w,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Log out'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _HelperListTile extends StatelessWidget {
  const _HelperListTile({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Colors.black,
      ),
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
