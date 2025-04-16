import 'package:crud_auth_test/app/modules/login/views/phone_login_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir email giriniz';
                  } else if (!value.contains('@')) {
                    return 'Lütfen geçerli bir email giriniz';
                  }
                  return null;
                },
                controller: controller.emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen bir şifre giriniz";
                  } else if (value.length < 6) {
                    return "Şifre en az 6 karakter olmalıdır";
                  }
                  return null;
                },
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Şifre',
                ),
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Get.to(() => const PhoneLogin());
                    },
                    child: const Text("Telefon numarası ile giriş yap")),
                TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Şifremi Unuttum"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: controller.resetEmailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email',
                                ),
                              ),
                              const Gap(20),
                              ElevatedButton(
                                onPressed: () {
                                  controller.resetPassword(
                                      controller.emailController.text);
                                  Get.back();
                                  controller.clearFields();
                                },
                                child: const Text('Gönder'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text("Şifrenizi mi unuttunuz?")),
              ],
            ),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        bool loginSuccess = await controller.login(
                          controller.emailController.text,
                          controller.passwordController.text,
                        );

                        if (loginSuccess) {
                          Get.offAllNamed('/home');
                        }
                      }
                    },
                    child: const Text('Giriş Yap'),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    child: const Text('Kayıt Ol'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
