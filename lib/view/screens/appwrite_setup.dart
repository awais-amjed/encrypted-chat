import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/custom_padding.dart';
import 'package:ecat/view/widgets/general/custom_text_field.dart';
import 'package:ecat/view/widgets/general/theme_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppWriteSetup extends StatelessWidget {
  const AppWriteSetup({Key? key, this.allowDarkMode = false}) : super(key: key);

  final bool allowDarkMode;

  @override
  Widget build(BuildContext context) {
    String id = 'ecat';
    String host =
        'https://8080-appwrite-integrationfor-o1wbqfvan8m.ws-eu44.gitpod.io/v1';
    final AppWriteController _appWriteController =
        Get.find(tag: K.appWriteControllerTag);
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);
    RxBool isSelfSigned = false.obs;

    return Scaffold(
      appBar: HelperFunctions.getAppBar(title: 'Customize Your Backend'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomPadding(
                    top: 2.h,
                    bottom: 8.h,
                    child: const Text(
                      'BE VARY THIS AREA IS FOR PROFESSIONALS ONLY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    initial: 'ecat',
                    label: 'Project ID',
                    image: 'assets/icons/id-card.png',
                    onChange: (_) {
                      id = _;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    initial: 'https://192.168.100.2/v1',
                    label: 'Endpoint',
                    image: 'assets/icons/cloud-server.png',
                    onChange: (_) {
                      host = _;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Set as Self Signed?\n- Choose Yes if you are hosting appwrite server on your local network, else you might get certificate error -',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Obx(
                        () => FlutterSwitch(
                          width: 80,
                          onToggle: (bool value) {
                            isSelfSigned.value = !isSelfSigned.value;
                          },
                          value: isSelfSigned.value,
                          activeColor: _themeController.isDarkMode.value
                              ? K.darkPrimary
                              : K.lightSecondary,
                          activeSwitchBorder: Border.all(
                            color: _themeController.isDarkMode.value
                                ? K.darkSecondary
                                : K.lightSecondary,
                            width: 2.0,
                          ),
                          inactiveColor: _themeController.isDarkMode.value
                              ? K.darkPrimary
                              : K.lightSecondary,
                          inactiveSwitchBorder: Border.all(
                            color: _themeController.isDarkMode.value
                                ? K.darkSecondary
                                : K.lightSecondary,
                            width: 2.0,
                          ),
                          activeText: 'YES',
                          inactiveText: 'NO',
                          showOnOff: true,
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    height: 50,
                    width: 195,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _appWriteController.updateParams(
                          id: id,
                          endPoint: host,
                          logout: !allowDarkMode,
                          context: !allowDarkMode ? context : null,
                          selfSigned: isSelfSigned.value,
                        );
                      },
                      child: const Text('Start Destruction'),
                    ),
                  ),
                  if (allowDarkMode) SizedBox(height: 10.h),
                  if (allowDarkMode) const ThemeSwitchButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
