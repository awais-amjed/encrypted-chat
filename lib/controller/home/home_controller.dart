import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }
}
