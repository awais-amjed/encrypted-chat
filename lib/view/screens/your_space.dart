import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:ecat/view/widgets/general/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:sizer/sizer.dart';

import '../../controller/storage/database_controller.dart';

class YourSpace extends StatelessWidget {
  const YourSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find(tag: K.userControllerTag);
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    RxBool uploading = false.obs;

    RxnString imagePath = RxnString();
    String name = _userController.userData.value.name;
    String oldPassword = '';
    String newPassword = '';

    imagePath.value = _userController.userData.value.imagePath;

    return Scaffold(
      appBar: HelperFunctions.getAppBar(
        title: 'Your Space',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  int? index;

                  index = await showAnimatedDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text(
                          'Pick an avatar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        children: [
                          Wrap(
                            children: List.generate(
                              47,
                              (index) => GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/saved/kitty ($index).png',
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                            alignment: WrapAlignment.center,
                          ),
                        ],
                      );
                    },
                    animationType: DialogTransitionType.scale,
                    duration: const Duration(milliseconds: 300),
                  );

                  if (index != null) {
                    imagePath.value = 'assets/images/saved/kitty ($index).png';
                  }
                },
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(
                        () => AvatarWidget(
                          size: 130,
                          image: imagePath.value,
                          imageFile: null,
                          borderWidth: 10,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 15.0, bottom: 8.0),
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: _themeController.isDarkMode.value
                                  ? K.darkSecondary
                                  : K.lightSecondary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: _themeController.isDarkMode.value
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                initial: name,
                label: 'Your Name',
                image: 'assets/icons/programmer.png',
                onChange: (_) {
                  name = _;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'If you want to update your password',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Old Password',
                image: 'assets/icons/secure.png',
                onChange: (_) {
                  oldPassword = _;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'New Password',
                image: 'assets/icons/secure.png',
                onChange: (_) {
                  newPassword = _;
                },
              ),
              SizedBox(height: 5.h),
              SizedBox(
                height: 50,
                width: 195,
                child: Obx(
                  () => ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (name == _userController.userData.value.name &&
                          imagePath.value ==
                              _userController.userData.value.imagePath &&
                          oldPassword == '' &&
                          newPassword == '') {
                        K.showToast(message: 'Nothing to Save');
                        Get.back();
                        return;
                      }

                      if (oldPassword.length < 8 || newPassword.length < 8) {
                        K.showToast(
                            message:
                                'Password needs to be at least 8 characters long');
                        return;
                      }

                      final DatabaseController _databaseController =
                          Get.find(tag: K.databaseControllerTag);
                      uploading.value = true;

                      bool proceed = false;
                      await _databaseController
                          .updatePassword(
                              oldPassword: oldPassword,
                              newPassword: newPassword)
                          .then((value) {
                        proceed = true;
                        K.showToast(message: 'Successfully updated Password');
                      }).catchError((e) {
                        K.showErrorToast(e);
                        uploading.value = false;
                      });
                      if (!proceed) {
                        return;
                      }

                      await _databaseController.updateUserData(
                        data: {
                          'name': name,
                          'image_path': imagePath.value,
                        },
                      ).then((value) async {
                        await _userController.updateUserFromRemote();
                        K.showToast(message: 'Successfully updated Profile');
                        Get.back();
                      }).catchError(K.showErrorToast);
                      uploading.value = false;
                    },
                    child: uploading.value
                        ? const CircularProgressIndicator()
                        : const Text('Confirm'),
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
