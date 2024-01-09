import 'package:cloud_firestore/cloud_firestore.dart';

class UserMember {
  final String uid;
  final String memberName;
  final String memberId;
  final String memberEmail;

  const UserMember({
    required this.uid,
    required this.memberName,
    required this.memberEmail,
    required this.memberId,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'memberName': memberName,
        'emailAddress': memberEmail,
        'memberId': memberId,
      };

  static UserMember fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserMember(
      uid: snap['uid'],
      memberName: snap['memberName'],
      memberEmail: snap['emailAddress'],
      memberId: snap['memberId'],
    );
  }

  factory UserMember.fromJson(Map<String, dynamic> json) {
    return UserMember(
      uid: json['uid'],
      memberName: json['memberName'],
      memberEmail: json['emailAddress'],
      memberId: json['memberId'],
    );
  }
}
