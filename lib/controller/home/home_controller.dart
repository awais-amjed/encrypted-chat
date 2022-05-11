import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    print("Toggle drawer");
    zoomDrawerController.toggle?.call();
    update();
  }
}
