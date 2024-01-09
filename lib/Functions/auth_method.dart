import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final notifications = NotificationsService();

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    String response = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _db.collection('users').doc(cred.user!.uid).set({
          'userName': userName,
          'uid': cred.user!.uid,
          'emailAddress': email,
        });

        await notifications.requestPermission();
        await notifications.getToken();

        response = "Success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        response = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        response = 'Password should be at least 6 characters';
      }
    } catch (err) {
      response = err.toString();
    }
    return response;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<UserProfile?> getUserInfo({String? uid}) async {
    uid ??= _auth.currentUser!.uid;

    DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    var snap = snapshot.data() as Map<String, dynamic>;
    if (snap['userName'] == null) {
      return null;
    }
    return UserProfile.fromSnapShot(snapshot);
  }
}
