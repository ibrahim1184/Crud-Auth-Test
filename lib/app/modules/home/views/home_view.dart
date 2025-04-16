import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<UserController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD İşlemleri'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: addUser(controller),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: logout(),
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.userList.length,
          itemBuilder: (context, index) {
            final user = controller.userList[index];
            return ListTile(
              leading: InkWell(
                onTap: () {
                  Get.to(Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: CachedNetworkImage(
                        imageUrl: user['filePath'] ??
                            'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    imageUrl: user['filePath'] ??
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  showPhoto(index),
                  editIcon(controller, user, index),
                  deleteIcon(controller, index),
                ],
              ),
              title: Text(user['name'] ?? ""),
              subtitle: Text('Yaş: ${user['age']}'),
            );
          },
        );
      }),
    );
  }

  Widget showPhoto(int index) {
    final isFilePathNull = controller.userList[index]['filePath'] == null;

    return IconButton(
      onPressed: () {
        if (isFilePathNull) {
          Get.dialog(AlertDialog(
            content: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.pickImageFromGallery(index);
                  },
                  child: const Text('Galeriden Yükle'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.pickImageFromCamera(index);
                  },
                  child: const Text('Kameradan Yükle'),
                ),
              ],
            ),
          ));
        } else {
          Get.snackbar("Hata", "Tekrar Yükleme Yasak");
        }
      },
      icon: Icon(isFilePathNull ? Icons.upload : Icons.photo),
    );
  }

  IconButton logout() {
    return IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Get.offAllNamed('/login');
        },
        icon: const Icon(Icons.logout));
  }

  IconButton addUser(UserController controller) {
    return IconButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Yeni Kayıt'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      hintText: 'Ad Soyad',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller.ageController,
                    decoration: const InputDecoration(
                      hintText: 'Yaş',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.clearFields();
                    Get.back();
                  },
                  child: const Text('Vazgeç'),
                ),
                TextButton(
                  onPressed: () {
                    controller.addUser(controller.nameController.text,
                        controller.ageController.text);
                    controller.clearFields();
                    Get.back();
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.add));
  }

  IconButton deleteIcon(UserController controller, int index) {
    return IconButton(
      onPressed: () {
        controller.deleteUser(index);
      },
      icon: const Icon(Icons.delete),
    );
  }

  IconButton editIcon(
      UserController controller, Map<String, String?> user, int index) {
    return IconButton(
      onPressed: () {
        controller.nameController.text = user['name'].toString();
        controller.ageController.text = user['age'].toString();
        Get.dialog(
          AlertDialog(
            title: const Text('Düzenle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    hintText: 'Ad Soyad',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controller.ageController,
                  decoration: const InputDecoration(
                    hintText: 'Yaş',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Vazgeç'),
              ),
              TextButton(
                onPressed: () async {
                  print(
                      'Name : ${controller.nameController.text}, Age: ${controller.ageController.text}');
                  await controller.updateUser(
                    index,
                    name: controller.nameController.text,
                    age: controller.ageController.text,
                  );
                  controller.clearFields();
                  Get.back();
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.edit),
    );
  }
}
