import 'dart:io';

import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/model/user_model.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //put storage contoroller
  final StorageService storageService = Get.put(StorageService());

  // image picker
  File? _image;
  void imageFromGallery() async {
    await storageService.imageFromGallery(_image);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 57, 111, 131), Color(0XFF262634)]),
        ),
        child: Scaffold(
            appBar: AppBar(title: const Text('Settings')),
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

                  return SettingsView(currentUser);
                })));
  }

  Widget SettingsView(UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(storageService.photoUrl.value),
            ),
            Positioned(
              bottom: -5,
              right: -10,
              child: IconButton(
                  onPressed: imageFromGallery,
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.grey.shade300,
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
        Text(
          user.email,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        MyButtton(label: 'Edit Profile', onTap: () {})
      ],
    );
  }
}
