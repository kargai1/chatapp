import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/pages/user_information_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 8, top: 8),
              child: GestureDetector(
                onTap: () {
                  Get.to(InformationScreen(user: user));
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 25,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
                child: Text(
              '${user.name} ${user.surName}',
              style: Theme.of(context).textTheme.headlineSmall,
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
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
        ? Theme.of(context).cardColor
        : Theme.of(context).primaryColor;

    var textColor = (message.senderId == _firebaseAuth.currentUser!.uid)
        ? Theme.of(context).scaffoldBackgroundColor
        : Theme.of(context).cardColor;

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
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
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
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
              onPressed: sendMessage,
            )
          ],
        ),
      ),
    );
  }
}
