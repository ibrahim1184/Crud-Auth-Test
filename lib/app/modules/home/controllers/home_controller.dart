import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userList = <Map<String, String?>>[].obs;
  final ImagePicker picker = ImagePicker();
  RxString imagePath = ''.obs;
  RxBool isLoading = false.obs;
  RxInt isLoadingIndex = 0.obs;

  void addUser(String name, String age) {
    userList.add({'name': name, 'age': age, 'filePath': null});
    saveUserListToFirestore();
  }

  // Firestore'a kullanıcı listesini kaydetmek için fonksiyon
  Future<void> saveUserListToFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        // Firestore'da user document'ine listeyi kaydet
        await firestore.collection('users').doc(user.uid).set(
          {
            'userList': userList
                .map((user) => {
                      'name': user['name'],
                      'age': user['age'],
                      'filePath': user['filePath'],
                    })
                .toList(),
          },
        );
      }
    } catch (e) {
      Get.snackbar("Hata", "Veri kaydedilemedi: $e");
    }
  }

  // Firestore'dan kullanıcı listesini çekmek için fonksiyon
  Future<void> loadUserListFromFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          List<dynamic> data = doc['userList'];
          userList.assignAll(data
              .map((item) => {
                    'name': item['name'] as String?,
                    'age': item['age'] as String?,
                    'filePath': item['filePath'] as String?
                  })
              .toList());
        }
      }
    } catch (e) {
      Get.snackbar("Hata", "Veri yüklenemedi: $e");
    }  
  }

  void deleteUser(int index) {
    userList.removeAt(index);
    saveUserListToFirestore();
  }

  Future<void> updateUser(int index,
      {String? name, String? age, String? filePath}) async {
    if (name != null) userList[index]['name'] = name;
    if (age != null) userList[index]['age'] = age;
    if (filePath != null) userList[index]['filePath'] = filePath;
    await saveUserListToFirestore();
    await loadUserListFromFirestore();
  }

  Future<void> pickImageFromCamera(int index) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      uploadFile(index, image.path, isLoadingIndex.value);
    } else {
      print('No image selected.');
    }
  }

  Future<void> pickImageFromGallery(int index) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadFile(index, image.path, isLoadingIndex.value);
    } else {
      print('No image selected.');
    }
  }

  //storage a dosya yükleme
  Future<void> uploadFile(
      int index, String filePath, int isLoadingIndex) async {
    isLoading.value = true;
    this.isLoadingIndex.value = index;
    try {
      File file = File(filePath);
      final splitted = filePath.split('/');
      isLoading.value = true;
      final fileRef = storage.ref(splitted.last);
      await fileRef.putFile(file);
      final downloadUrl = await fileRef.getDownloadURL();
      await updateUser(index, filePath: downloadUrl);

      ///filePath
    } on FirebaseException catch (e) {
      //firebaseexcepiton olmasa da olur mu
      print(e.toString());
    } finally {
      isLoading.value = false;
      this.isLoadingIndex.value = -1;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserListFromFirestore();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    super.onClose();
  }

  void clearFields() {
    nameController.clear();
    ageController.clear();
  }
}
