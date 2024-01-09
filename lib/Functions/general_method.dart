import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Models/user.dart';
import 'package:command_accepted/Models/user_alarm.dart';
import 'package:command_accepted/Models/user_command.dart';
import 'package:command_accepted/Models/user_member.dart';
import 'package:command_accepted/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralMethod {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DateTime currentDate = DateTime.now();

  ///////Command Update///////
  Future<void> updateCommandStatus(
      String status, String currentCommandRoom, String commandId) async {
    await _db
        .collection('commandRooms')
        .doc(currentCommandRoom)
        .collection('commands')
        .doc(commandId)
        .update({'status': status});
  }

  //////Util//////
  void signOut() {
    _auth.signOut();
  }

  /////Alarm/////
  Future<String> sendAlarm(
    String receiverId,
    String receiverEmail,
    String receiverName,
    String status,
    String alarmId,
    String alarmVersion,
    String senderName,
  ) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final String timeStamp = datetimeToString(DateTime.now());
    String result = 'error';

    try {
      UserAlarm newCommand = UserAlarm(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        senderName: senderName,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
        receiverName: receiverName,
        timeStamp: timeStamp,
        status: status,
        alarmId: alarmId,
        alarmVersion: alarmVersion,
      );

      await _db
          .collection('alarmRooms')
          .doc(receiverId)
          .collection('alarms')
          .doc(alarmId)
          .set(newCommand.toJson());

      await _db
          .collection('alarmRooms')
          .doc(currentUserId)
          .collection('alarms')
          .doc(alarmId)
          .set(newCommand.toJson());

      result = 'Success';

      QuerySnapshot commandQuery = await _db
          .collection('alarmRooms')
          .doc(receiverId)
          .collection('alarms')
          .where('alarmId', isEqualTo: alarmId)
          .get();
      if (commandQuery.docs.isEmpty) {
        result = 'Your request couldn\'t be sent';
        return result;
      }
    } catch (error) {}
    return result;
  }

  Stream<QuerySnapshot> getAlarms(String receiverId) {
    return _db
        .collection('alarmRooms')
        .doc(receiverId)
        .collection('alarms')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<void> updateAlarmStatus(
      String status, String receiverId, String alarmId) async {
    await _db
        .collection('alarmRooms')
        .doc(receiverId)
        .collection('alarms')
        .doc(alarmId)
        .update({'status': status});
  }

  //////Send Receive Command//////
  Future<String> sendCommand(
    String receiverId,
    String title,
    String? location,
    var startTimeInt,
    var endTimeInt,
    String? note,
    String status,
    String startTimeString,
    String endTimeString,
    String commandId,
  ) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final String timeStamp = datetimeToString(DateTime.now());
    String result = 'error';
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String commandRoomId = ids.join('_');
    try {
      Command newCommand = Command(
          senderId: currentUserId,
          senderName: currentUserEmail,
          receiverId: receiverId,
          timeStamp: timeStamp,
          title: title,
          location: location,
          startTimeInt: startTimeInt,
          endTimeInt: endTimeInt,
          note: note,
          status: status,
          startTimeString: startTimeString,
          endTimeString: endTimeString,
          commandId: commandId,
          commandRoomId: commandRoomId);

      await _db
          .collection('commandRooms')
          .doc(commandRoomId)
          .collection('commands')
          .doc(commandId)
          .set(newCommand.toJson());

      result = 'Success';

      QuerySnapshot commandQuery = await _db
          .collection('commandRooms')
          .doc(commandRoomId)
          .collection('commands')
          .where('commandId', isEqualTo: commandId)
          .get();
      if (commandQuery.docs.isEmpty) {
        result = 'Your command couldn\'t be sent';
        return result;
      }
    } catch (error) {}
    return result;
  }

  Stream<QuerySnapshot> getCommands(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String commandRoomId = ids.join('_');

    return _db
        .collection('commandRooms')
        .doc(commandRoomId)
        .collection('commands')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

//////User//////

  Future<List<COMMACUser>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .get(const GetOptions(source: Source.cache));
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _db
            .collection('users')
            .get(const GetOptions(source: Source.server));
      }
      List<COMMACUser> users = querySnapshot.docs
          .map((doc) => COMMACUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print(users[0].uid);
      return users;
    } catch (error) {}
    return [];
  }

  Future<List<COMMACUser>> searchUser(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .where('emailAddress', isEqualTo: userEmail)
          .get();
      List<COMMACUser> searchedUsers = querySnapshot.docs
          .map((doc) => COMMACUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return searchedUsers;
    } catch (error) {
      print(Text('$error'));
      return [];
    }
  }

  //////Member//////
  Future<String> addMember(String uid, String memberName, String memberEmail,
      String memberId) async {
    String result = 'error';
    try {
      QuerySnapshot emailQuery =
          await _db.collection('userMember').where('uid', isEqualTo: uid).get();
      if (emailQuery.docs.isNotEmpty) {
        result = 'Existing member. Please check again.';
        return result;
      }

      UserMember member = UserMember(
        uid: uid,
        memberName: memberName,
        memberEmail: memberEmail,
        memberId: memberId,
      );

      await _db
          .collection('userMember')
          .doc(uid)
          .collection('member')
          .doc(memberId)
          .set(member.toJson());

      result = 'Success';
    } catch (error) {}
    return result;
  }

  Future<List<UserMember>> getMembers() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('userMember')
          .doc(uid)
          .collection('member')
          .get(const GetOptions(source: Source.serverAndCache));

      List<UserMember> members = querySnapshot!.docs
          .map((doc) => UserMember.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return members;
    } catch (error) {}
    return [];
  }

  Future<String> deleteMember(String memberId) async {
    try {
      await _db
          .collection('userMember')
          .doc(uid)
          .collection('member')
          .doc(memberId)
          .delete();
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
