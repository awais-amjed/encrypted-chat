import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/custom_padding.dart';
import 'package:ecat/view/widgets/general/theme_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppWriteSetup extends StatelessWidget {
  const AppWriteSetup({Key? key, this.allowDarkMode = false}) : super(key: key);

  final bool allowDarkMode;

  @override
  Widget build(BuildContext context) {
    String id = '';
    String host = '';
    final AppWriteController _appWriteController =
        Get.find(tag: K.appWriteControllerTag);
    final ThemeController _ = Get.find(tag: K.themeControllerTag);

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
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text('Project ID'),
                      icon: Image.asset(
                        'assets/icons/id-card.png',
                        width: 50,
                      ),
                      hintText: 'ecat',
                    ),
                    onChanged: (_) {
                      id = _;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text('Endpoint'),
                      icon: Image.asset(
                        'assets/icons/cloud-server.png',
                        width: 50,
                      ),
                      hintText: '192.168.100.2/v1',
                    ),
                    onChanged: (_) {
                      host = _;
                    },
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 50,
                    width: 200,
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
                            id: id, endPoint: host);
                      },
                      child: const Text('Start Destruction'),
                    ),
                  ),
                  if (allowDarkMode) SizedBox(height: 20.h),
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
