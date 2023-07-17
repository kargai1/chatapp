import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/pages/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth/auth_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.put(AuthService());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign out
  signOut() {
    setState(() {
      authController.signOut();
    });
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
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            // sing out button
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
          ],
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error..');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    UserModel user = UserModel.fromJson(data);
    if (_auth.currentUser!.email != user.email) {
      return Column(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                  onTap: () {
                    Get.to(ChatPage(
                      user: user,
                    ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                      radius: 40,
                    ),
                    title: Text(user.name + ' ' + user.surName),
                    subtitle: Text(user.email),
                  ))),
          const Divider(
            color: Colors.white,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
