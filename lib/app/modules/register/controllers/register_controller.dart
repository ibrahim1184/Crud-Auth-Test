import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  Future <void> register(String email, String password)async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
   
    Get.snackbar("Başarılı", "Kullanıcı oluşturuldu", backgroundColor: Colors.green); 
     }catch(e){
       Get.snackbar("Hata", e.toString(), backgroundColor: Colors.red);
     }
  }






}
