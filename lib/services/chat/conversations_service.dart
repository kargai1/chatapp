import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ConversationService extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream userStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  Future<List<UserModel>> getUserList() async {
    List<UserModel> userList =
        await userStream.map((event) => UserModel.fromJson(event)).toList();

    return userList;
  }

  Future getChatRooms() async {
    List<UserModel> userList = await getUserList();
    List<UserModel> newUserList = [];
    var ref = FirebaseFirestore.instance.collection('chat_rooms');
    var documents = ref.get();

    for (UserModel user in userList) {
      List ids = [_auth.currentUser!.uid, user.userId];
      ids.sort();
      String chatRoomId = ids.join('_');
    }
  }
}
