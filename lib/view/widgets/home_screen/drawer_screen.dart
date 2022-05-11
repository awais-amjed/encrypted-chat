import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
              SizedBox(
                width: 100,
                child: Obx(
                  () => FlutterSwitch(
                    width: 100,
                    height: 45.0,
                    toggleSize: 28.0,
                    value: toggle.value,
                    borderRadius: 17.0,
                    padding: 2.0,
                    activeToggleColor: const Color(0xFF6E40C9),
                    inactiveToggleColor: const Color(0xFF2F363D),
                    activeSwitchBorder: Border.all(
                      color: const Color(0xFF3C1E70),
                      width: 6.0,
                    ),
                    inactiveSwitchBorder: Border.all(
                      color: const Color(0xFFD1D5DA),
                      width: 6.0,
                    ),
                    activeColor: const Color(0xFF271052),
                    inactiveColor: Colors.white,
                    activeIcon: const Icon(
                      Icons.nightlight_round,
                      color: Color(0xFFF8E3A1),
                    ),
                    inactiveIcon: const Icon(
                      Icons.wb_sunny,
                      color: Color(0xFFFFDF5D),
                    ),
                    onToggle: (val) {
                      toggle.value = val;
                    },
                  ),
                ),
              ),
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
