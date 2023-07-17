import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;

  const ChatPage({
    super.key,
    required this.user,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService chatService = Get.put(ChatService());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.user.userId, _messageController.text);
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = widget.user;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 57, 111, 131), Color(0XFF262634)]),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 25,
                ),
              ),
              Flexible(child: Text('${user.name} ${user.surName}')),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(
          widget.user.userId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Message message = Message.fromJson(data);

    // align messages

    var aligment = (message.senderId == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    // colors
    var color = (message.senderId == _firebaseAuth.currentUser!.uid)
        ? Colors.blueGrey.shade200
        : Colors.indigo.shade200;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: aligment,
        child: Column(
          crossAxisAlignment:
              (message.senderId == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (message.senderId == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            ChatBubble(
              message: message.message,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child:
                // message input
                MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),

          //send button

          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          )
        ],
      ),
    );
  }
}
