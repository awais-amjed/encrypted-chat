import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class QRCode extends StatelessWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EncryptionController _encryptionController =
        Get.find(tag: K.encryptionControllerTag);

    return Scaffold(
      appBar: HelperFunctions.getAppBar(title: 'Private Key', actions: [
        SizedBox(
          width: 80,
          child: TextButton(
            onPressed: () {},
            child: const Text('Import'),
          ),
        ),
      ]),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 4.h),
              const Text(
                'Take a Screenshot of your QR Code if you are planning to switch devices.\n\n'
                'This QR Code contains your private key and you can import it on the new device using the import button above and selecting the screenshot.\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Text(
                "Keep in mind, if you loose your private key and don't have a backup, YOU WILL loose all of your data and recovery is impossible without the private key, "
                "because all your messages are encrypted with this private key. Also DON'T SHARE it with anyone unless you want them to read your messages of course \\p-p/",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5.h),
              Center(
                child: QrImage(
                  data: _encryptionController.privateKey.toString(),
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
