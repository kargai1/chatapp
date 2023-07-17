import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatService extends GetxController {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // its a Set for the get contacts

  // Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newmessage = Message(
      currentUserId,
      currentUserEmail,
      receiverId,
      message,
      timestamp,
    );
    //construct chat room id from current user id and receiver id
    List<String> ids = [currentUserId, receiverId];
    //ids sorted
    ids.sort();
    // chatroom id has created
    String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newmessage.toMap());

    //add receivers id to Set
    //Contact set as map

    // add firestore the contact's id's
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('contacts')
        .add({'contacts': receiverId});

    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('contacts')
        .add({'contacts': _firebaseAuth.currentUser!.uid});
  }

  //Get Messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();

    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
