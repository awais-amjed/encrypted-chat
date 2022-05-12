import 'package:crypton/crypton.dart';
import 'package:ecat/controller/encryption/encryption_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:ecat/model/helper_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../controller/storage/local_storage_controller.dart';

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
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                final String data =
                    await FlutterQrReader.imgScan(result.files.single.path!);
                K.showDialog(
                  context: context,
                  title: 'Save your Private Key?',
                  cancelText: 'Yes',
                  confirmText: 'No',
                  content:
                      'This will override any previous keys saved on this device. So be careful! Do you want to proceed anyway?',
                  onCancel: () {
                    final LocalStorageController _local =
                        Get.find(tag: K.localStorageControllerTag);
                    _encryptionController.privateKey =
                        RSAPrivateKey.fromString(data);
                    _local.savePrivateKey(privateKey: data);
                  },
                );
              } else {}
            },
            child: const Text(
              'Import',
              style: TextStyle(color: Colors.white),
            ),
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
