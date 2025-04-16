import 'package:crud_auth_test/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
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
              const Gap(20),
              TextFormField(
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
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.register(
                                  controller.emailController.text,
                                  controller.passwordController.text);
                              Get.offAll(() => const LoginView());
                            }
                          },
                          child: const Text('Kayıt Ol')))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
