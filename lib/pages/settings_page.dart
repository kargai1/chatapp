import 'dart:io';

import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //put auth contorller for update user information
  final AuthService _authService = Get.put(AuthService());

  //put storage contoroller
  final StorageService storageService = Get.put(StorageService());

  // image picker
  File? _image;
  void imageFromGallery() async {
    await storageService.imageFromGallery(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        )),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              UserModel currentUser = UserModel.fromJson(data);
              storageService.photoUrl.value = currentUser.photoUrl;

              return settingsView(currentUser);
            }));
  }

  Widget settingsView(UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Obx(
              () => CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(storageService.photoUrl.value),
              ),
            ),
            Positioned(
              bottom: -5,
              right: -10,
              child: IconButton(
                  onPressed: imageFromGallery,
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyTextField(
            controller: nameController,
            hintText: user.name,
            obscureText: false),
        MyTextField(
            controller: surNameController,
            hintText: user.surName,
            obscureText: false),
        MyTextField(
          controller: descriptionController,
          hintText: user.description,
          obscureText: false,
        ),
        Text(
          user.email,
        ),
        const Divider(),
        MyButtton(
            label: 'Edit Profile',
            onTap: () async {
              if (nameController.text.isEmpty) {
                _authService.updateUserInfo(
                  user.userId,
                  user.email,
                  user.name,
                  surNameController.text,
                  storageService.photoUrl.value,
                );
              } else if (surNameController.text.isEmpty) {
                _authService.updateUserInfo(
                  user.userId,
                  user.email,
                  nameController.text,
                  user.surName,
                  storageService.photoUrl.value,
                );
              } else {
                _authService.updateUserInfo(
                    user.userId,
                    user.email,
                    nameController.text,
                    surNameController.text,
                    storageService.photoUrl.value);
              }

              setState(() {
                nameController.clear();
                surNameController.clear();
              });
            })
      ],
    );
  }
}
