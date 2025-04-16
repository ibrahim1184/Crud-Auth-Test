import 'package:crud_auth_test/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneLogin extends GetView<LoginController> {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Telefon numarası ile giriş yap'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                keyboardType: TextInputType.phone, 
                controller: controller.phoneNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Telefon numarası giriniz',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
              
                  controller.sendVerificationCode();
                },
                child:  Obx((){
                  return controller.isLoading.value ? const CircularProgressIndicator() : const Text('Kodu Gönder');
                })),
          ],
        ));
  }
}
