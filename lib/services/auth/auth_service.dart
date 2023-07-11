import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future singInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // add a new document for the user in users collection if it doesn't alreadt exists
      _firestore.collection("users").doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  // sign out
  signOut() async {
    await _firebaseAuth.signOut();
  }

  // create a user
  Future singUpWithEmailAndPassword(String email, String password, String name,
      String surName, String photoUrl) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      singInWithEmailAndPassword(email, password);
      Get.snackbar('Done!', 'You can login now');

      _firestore.collection("users").doc(userCredential.user!.uid).set(
          UserModel.toJson(UserModel(
              userCredential.user!.uid, email, name, surName, photoUrl)));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }
}
