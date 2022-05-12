import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:ecat/controller/theme_controller.dart';
import 'package:ecat/controller/user_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:ecat/view/widgets/general/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../controller/app_write_controller.dart';

class YourSpace extends StatelessWidget {
  const YourSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find(tag: K.userControllerTag);
    final ThemeController _themeController =
        Get.find(tag: K.themeControllerTag);

    final TextEditingController _textController = TextEditingController();

    Rxn<File> imageFile = Rxn<File>();
    RxnString imagePath = RxnString();
    String name = _userController.userData.value.name;
    String previousPassword = '';
    String newPassword = '';

    _textController.text = name;

    imagePath.value = _userController.userData.value.imagePath;

    final AppWriteController _appWriteController =
        Get.find(tag: K.appWriteControllerTag);
    Storage _storage = Storage(_appWriteController.client);

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
                  bool? result = await K.showDialog(
                    context: context,
                    title: 'Where do you want to pick from?',
                    cancelText: 'Avatar',
                    confirmText: 'Gallery',
                    onConfirm: () async {
                      final XFile? image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        return;
                      }
                      imageFile.value = File(image.path);
                    },
                    onCancel: () async {
                      return true;
                    },
                  );

                  if (result == true) {
                    index = await showAnimatedDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text(
                            'Pick an avatar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                  }

                  if (index != null) {
                    imageFile.value = null;
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
                          imageFile: imageFile.value,
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
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  label: const Text('Your Name'),
                  icon: Image.asset(
                    'assets/icons/programmer.png',
                    width: 50,
                  ),
                ),
                onChanged: (_) {
                  name = _;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'If you want to update your password',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  label: const Text('Previous Password'),
                  icon: Image.asset(
                    'assets/icons/secure.png',
                    width: 50,
                  ),
                ),
                onChanged: (_) {
                  previousPassword = _;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  label: const Text('New Password'),
                  icon: Image.asset(
                    'assets/icons/secure.png',
                    width: 50,
                  ),
                ),
                onChanged: (_) {
                  newPassword = _;
                },
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
                  onPressed: () async {
                    // final DatabaseController _databaseController =
                    //     Get.find(tag: K.databaseControllerTag);
                    // if (name != '') {
                    //   _databaseController.updateUserData(data: {});
                    // }
                    _storage.createFile(
                      bucketId: 'avatars',
                      fileId: 'userID',
                      file: InputFile(
                        file: await MultipartFile.fromPath(
                          'file',
                          imageFile.value!.path,
                        ),
                        path: imageFile.value!.path,
                      ),
                    );
                  },
                  child: const Text('Update Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
