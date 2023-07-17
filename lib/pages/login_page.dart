import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.put(AuthService());

  void signIn() async {
    await authController.singInWithEmailAndPassword(
        emailController.text, passwordController.text);
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const Icon(
                      Icons.chat,
                      size: 100,
                    ),
                    const Text('W E L C O M E   B A C K',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 10),
                    MyButtton(label: "Sign In", onTap: signIn),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member"),
                        TextButton(
                          onPressed: widget.onTap,
                          child: const Text(
                            "Register Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
