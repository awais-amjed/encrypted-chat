import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPadding extends StatelessWidget {
  const CustomPadding({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.child,
  }) : super(key: key);

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        left ?? 2.w,
        top ?? 2.w,
        right ?? 2.w,
        bottom ?? 2.w,
      ),
      child: child,
    );
  }
}
