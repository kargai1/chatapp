import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsversationsPage extends StatefulWidget {
  const ConsversationsPage({super.key});

  @override
  State<ConsversationsPage> createState() => _ConsversationsPageState();
}

class _ConsversationsPageState extends State<ConsversationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recently Conversations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: _buildConversationsList());
  }

  Widget _buildConversationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List contactsList =
            snapshot.data!.docs.map((doc) => doc.data()).toList();
        List list = [];

        for (int i = 0; i < contactsList.length; i++) {
          list.add(contactsList[i]['contacts']);
        }

        List noDuplicateList = list.toSet().toList();
        return ListView.builder(
          itemCount: noDuplicateList.length,
          itemBuilder: (context, index) =>
              _buildConversationItem(noDuplicateList[index]),
        );
      },
    );
  }

  Widget _buildConversationItem(String userId) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error..');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        UserModel user = UserModel.fromJson(data);
        return Card(
          child: GestureDetector(
            onTap: () {
              Get.to(ChatPage(user: user));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text('${user.name} ${user.surName}'),
              ),
            ),
          ),
        );
      },
    );
  }
}
