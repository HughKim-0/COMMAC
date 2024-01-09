import 'package:cloud_firestore/cloud_firestore.dart';

class UserAlarm {
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String timeStamp;
  final String status;
  final String receiverId;
  final String receiverEmail;
  final String receiverName;
  final String alarmId;
  final String alarmVersion;

  const UserAlarm({
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.status,
    required this.receiverId,
    required this.receiverEmail,
    required this.receiverName,
    required this.timeStamp,
    required this.alarmId,
    required this.alarmVersion,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'senderEmail': senderEmail,
        'senderName': senderName,
        'status': status,
        'receiverId': receiverId,
        'receiverEmail': receiverEmail,
        'receiverName': receiverName,
        'timeStamp': timeStamp,
        'alarmId': alarmId,
        'alarmVersion': alarmVersion,
      };

  static UserAlarm fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserAlarm(
      senderId: snap['senderId'],
      senderEmail: snap['senderEmail'],
      senderName: snap['senderName'],
      status: snap['status'],
      receiverId: snap['receiverId'],
      receiverEmail: snap['receiverEmail'],
      receiverName: snap['receiverName'],
      timeStamp: snap['timeStamp'],
      alarmId: snap['alarmId'],
      alarmVersion: snap['alarmVersion'],
    );
  }

  factory UserAlarm.fromJson(Map<String, dynamic> json) {
    return UserAlarm(
      senderId: json['senderId'],
      senderEmail: json['senderEmail'],
      senderName: json['senderName'],
      status: json['status'],
      receiverId: json['receiverId'],
      receiverEmail: json['receiverEmail'],
      receiverName: json['receiverName'],
      timeStamp: json['timeStamp'],
      alarmId: json['alarmId'],
      alarmVersion: json['alarmVersion'],
    );
  }
}
