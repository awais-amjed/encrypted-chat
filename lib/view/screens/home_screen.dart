import 'package:appwrite/appwrite.dart';
import 'package:crypton/crypton.dart';
import 'package:ecat/controller/app_write_controller.dart';
import 'package:ecat/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void getKeyPair() async {
      RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
      String message = 'meow';

      print(rsaKeypair.publicKey);

      String encrypted = rsaKeypair.publicKey.encrypt(message);
      String decrypted = rsaKeypair.privateKey.decrypt(encrypted);

      AppWriteController _ = Get.find(tag: K.appWriteControllerTag);
      Database database = Database(_.client);

      Future result = database.createDocument(
        collectionId: 'users',
        documentId: 'meow',
        data: {'name': 'meow'},
        read: ['role:all'],
      );

      result.then((response) {
        print(response);
      }).catchError((error) {
        print(error.response);
      });
    }

    getKeyPair();

    return const Scaffold();
  }
}
