import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController( );
  final passwordController = TextEditingController( );
  final formKey = GlobalKey<FormState>();
  final resetEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final smsController = TextEditingController();
  var isLoading = false.obs;

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar("Başarılı", "Giriş Yapıldı", backgroundColor: Colors.green);
      return true;
    } catch (e) {
      Get.snackbar("Hata", e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase'den çıkış yap
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Hata', 'Çıkış yapılamadı. Lütfen tekrar deneyin.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmailController.text);
      Get.snackbar("Başarılı", "Şifre sıfırlama maili gönderildi",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Hata", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> sendVerificationCode() async {
    isLoading(true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Hata', e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading(false);

          Get.defaultDialog(
            title: 'Kod Gönderildi',
            content: Column(
              children: [
                TextField(
                  controller: smsController,
                  decoration: const InputDecoration(labelText: 'Kodu Giriniz'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: smsController.text,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      Get.offAllNamed('/home');
                    } catch (e) {
                      Get.snackbar('Hata', e.toString());
                    }
                  },
                  child: const Text('Doğrula'),
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
