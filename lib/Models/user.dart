import 'package:cloud_firestore/cloud_firestore.dart';

class COMMACUser {
  final String uid;
  final String userName;
  final String userEmail;

  const COMMACUser({
    required this.uid,
    required this.userName,
    required this.userEmail,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'userEmail': userEmail,
      };

  static COMMACUser fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return COMMACUser(
      uid: snap['uid'],
      userName: snap['userName'],
      userEmail: snap['userEmail'],
    );
  }

  factory COMMACUser.fromJson(Map<String, dynamic> json) {
    return COMMACUser(
      uid: json['uid'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }
}
