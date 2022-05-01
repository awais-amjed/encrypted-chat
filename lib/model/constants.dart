import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class K {
  // Colors
  // TODO Colors to be decided

  // Controller tags
  static const String appWriteControllerTag = 'appWriteControllerTag';
  static const String userControllerTag = 'userControllerTag';
  static const String localStorageControllerTag = 'localStorageControllerTag';
  static const String databaseControllerTag = 'databaseControllerTag';
  static const String encryptionControllerTag = 'encryptionControllerTag';

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
      duration: const Duration(seconds: 300),
    );
  }
}
