import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class K {
  // Colors
  static const Color whiteText = Colors.white;
  static const Color blackText = Colors.black;
  static const Color lightPrimary = Colors.white;
  static const Color lightSecondary = Color(0xFFf02e65);
  static const Color darkPrimary = Color(0xff171d37);
  static const Color darkSecondary = Color(0xFFc7d8eb);
  static const Color darkAppbar = Color(0xff13182d);

  // Controller tags
  static const String appWriteControllerTag = 'appWriteControllerTag';
  static const String userControllerTag = 'userControllerTag';
  static const String localStorageControllerTag = 'localStorageControllerTag';
  static const String databaseControllerTag = 'databaseControllerTag';
  static const String encryptionControllerTag = 'encryptionControllerTag';
  static const String usersListControllerTag = 'usersListControllerTag';
  static const String homeControllerTag = 'homeControllerTag';
  static const String notificationControllerTag = 'notificationControllerTag';
  static const String themeControllerTag = 'themeControllerTag';
  static const String searchControllerTag = 'searchControllerTag';

  // Functions
  static void showToast({required String message, Toast? toastLength}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static showErrorToast(error) {
    showToast(message: error.toString());
  }

  static getRandomImage() {
    return 'assets/images/saved/kitty (${0 + Random().nextInt(47)}).png';
  }

  static Future<void> showDialog({
    required BuildContext context,
    String? title,
    String? content,
    String? cancelText,
    String? confirmText,
    Function? onConfirm,
    Function? onCancel,
  }) {
    return showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: content,
          negativeText: cancelText,
          positiveText: confirmText,
          onPositiveClick: () {
            Navigator.of(context).pop(onConfirm != null ? onConfirm() : null);
          },
          onNegativeClick: () {
            Navigator.of(context).pop(onCancel != null ? onCancel() : null);
          },
        );
      },
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 300),
    );
  }
}
