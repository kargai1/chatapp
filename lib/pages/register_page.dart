import 'dart:io';

import 'package:chat_app/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();
  final surNameController = TextEditingController();

  final AuthService authController = Get.find();

  //put storage contoroller
  final StorageService storageService = Get.put(StorageService());

  // image picker
  File? _image;
  void imageFromGallery() async {
    await storageService.imageFromGallery(_image);

    setState(() {});
  }

  signUp() async {
    if (confirmController.text == passwordController.text) {
      //create a new user

      await authController.singUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          nameController.text,
          surNameController.text,
          storageService.photoUrl.value);

      emailController.clear();
      passwordController.clear();
      confirmController.clear();
    } else {
      // get an error
      Get.snackbar("Error", "Passwords do not match!");

      emailController.clear();
      passwordController.clear();
      confirmController.clear();
    }
  }

  @override
  void initState() {
    storageService.photoUrl.value =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Gnome-stock_person.svg/800px-Gnome-stock_person.svg.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('C H A T M E ',
                        style: Theme.of(context).textTheme.titleLarge),
                    Icon(
                      Icons.chat,
                      size: 50,
                      color: Theme.of(context).cardColor,
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Obx(() => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(storageService.photoUrl.value),
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: -5,
                      right: -12,
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
                Text('W E L C O M E',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    controller: nameController,
                    hintText: "Name",
                    obscureText: false),
                MyTextField(
                    controller: surNameController,
                    hintText: "Surname",
                    obscureText: false),
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false),
                MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true),
                MyTextField(
                    controller: confirmController,
                    hintText: "Confirm your password",
                    obscureText: true),
                MyButtton(label: "Sign Up", onTap: signUp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        "Login Now",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
