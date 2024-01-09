import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String userName;
  final String emailAddress;
  final String? phoneNumber;

  const UserProfile({
    required this.uid,
    required this.userName,
    required this.emailAddress,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
      };

  static UserProfile fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserProfile(
      uid: snap['uid'],
      userName: snap['userName'],
      emailAddress: snap['emailAddress'],
      phoneNumber: snap['phoneNUmber'],
    );
  }
}
