import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class HelperFunctions {
  static getAppBar({
    String? title,
    Widget? leading,
    List<Widget>? actions,
    double? leadingWidth,
  }) {
    return AppBar(
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              style: const TextStyle(
                color: K.whiteText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      toolbarHeight: 80,
      elevation: 2,
      leading: leading,
      actions: actions,
      leadingWidth: leadingWidth,
    );
  }

  static getDateOrTime({required DateTime dateTime}) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes == 0) {
      return 'Just Now';
    } else if (difference.inMinutes == 1) {
      return 'a minutes ago';
    } else if (difference.inMinutes > 1 && difference.inMinutes < 10) {
      return 'a few minutes ago';
    } else if (difference.inDays == 0) {
      return DateFormat.jm().format(dateTime);
    } else if (difference.inDays > 356) {
      return DateFormat('MMMM d, y').format(dateTime);
    } else if (difference.inDays > 0) {
      return DateFormat('MMMM d').format(dateTime);
    }
  }
}
