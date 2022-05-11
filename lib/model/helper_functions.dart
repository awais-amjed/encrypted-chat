import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  static getAppBar({
    required String title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
      ),
      toolbarHeight: 80,
      // backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      leading: leading,
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
