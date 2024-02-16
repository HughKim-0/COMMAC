import 'package:cloud_firestore/cloud_firestore.dart';

class BridgeCommandedMember {
  String? memberName;
  String? memberId;
  String? memberEmail;
  String? memberPhone;
  String? memberToken;

  BridgeCommandedMember({
    this.memberName,
    this.memberId,
    this.memberEmail,
    this.memberPhone,
    this.memberToken,
  });

  Map<String, dynamic> toJson() => {
        'memberName': memberName,
        'memberId': memberId,
        'emailAddress': memberEmail,
        'phoneNumber': memberPhone,
        'memberToken': memberToken,
      };

  static BridgeCommandedMember fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return BridgeCommandedMember(
      memberName: snap['memberName'],
      memberId: snap['memberId'],
      memberEmail: snap['emailAddress'],
      memberPhone: snap['phoneNumber'],
      memberToken: snap['memberToken'],
    );
  }

  factory BridgeCommandedMember.fromJson(Map<String, dynamic> json) {
    return BridgeCommandedMember(
      memberName: json['memberName'],
      memberId: json['memberId'],
      memberEmail: json['emailAddress'],
      memberPhone: json['phoneNumber'],
      memberToken: json['memberToken'],
    );
  }
}

class Command {
  final String senderId;
  final String senderName;
  final String title;
  final String? location;
  final String? note;
  final String timeStamp;
  final String status;
  final String receiverId;
  final int startTimeInt;
  final int endTimeInt;
  final String startTimeString;
  final String endTimeString;
  final String commandId;
  final String commandRoomId;
  final DateTime timeDummy;

  const Command({
    required this.senderId,
    required this.senderName,
    required this.title,
    this.location,
    this.note,
    required this.status,
    required this.receiverId,
    required this.timeStamp,
    required this.startTimeInt,
    required this.endTimeInt,
    required this.startTimeString,
    required this.endTimeString,
    required this.commandId,
    required this.commandRoomId,
    required this.timeDummy,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'senderName': senderName,
        'title': title,
        'location': location,
        'note': note,
        'status': status,
        'receiverId': receiverId,
        'timeStamp': timeStamp,
        'startTimeInt': startTimeInt,
        'endTimeInt': endTimeInt,
        'startTimeString': startTimeString,
        'endTimeString': endTimeString,
        'commandId': commandId,
        'commandRoomId': commandRoomId,
        'timeDummy': timeDummy,
      };

  static Command fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Command(
      senderId: snap['senderId'],
      senderName: snap['senderName'],
      title: snap['title'],
      location: snap['location'],
      note: snap['note'],
      status: snap['status'],
      receiverId: snap['receiverId'],
      timeStamp: snap['timeStamp'],
      startTimeInt: snap['startTimeInt'],
      endTimeInt: snap['endTimeInt'],
      startTimeString: snap['startTimeString'],
      endTimeString: snap['endTimeString'],
      commandId: snap['commandId'],
      commandRoomId: snap['commandRoomId'],
      timeDummy: snap['timeDummy'],
    );
  }

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      senderId: json['senderId'],
      senderName: json['senderName'],
      title: json['title'],
      location: json['location'],
      note: json['note'],
      status: json['status'],
      receiverId: json['receiverId'],
      timeStamp: json['timeStamp'],
      startTimeInt: json['startTimeInt'],
      endTimeInt: json['endTimeInt'],
      startTimeString: json['startTimeString'],
      endTimeString: json['endTimeString'],
      commandId: json['commandId'],
      commandRoomId: json['commandRoomId'],
      timeDummy: json['timeDummy'],
    );
  }
}
