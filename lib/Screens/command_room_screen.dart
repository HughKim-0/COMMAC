import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Widgets/command_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommandRoomScreen extends StatefulWidget {
  final String receiverUserId;
  final String receiverUserName;
  const CommandRoomScreen({
    super.key,
    required this.receiverUserId,
    required this.receiverUserName,
  });

  @override
  State<CommandRoomScreen> createState() => _CommandRoomScreenState();
}

class _CommandRoomScreenState extends State<CommandRoomScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commandController = TextEditingController();
  final notificationMethod = NotificationsService();

  @override
  void initState() {
    notificationMethod.firebaseNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName,
            style: Theme.of(context).textTheme.displayLarge),
        centerTitle: true,
        backgroundColor: thirdColor,
      ),
      body: Container(
        color: primaryColor,
        child: Column(
          children: [
            Expanded(
              child: _buildCommandList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandList() {
    return StreamBuilder(
      stream: GeneralMethod()
          .getCommands(widget.receiverUserId, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildCommandItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildCommandItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['timeStamp']),
            const SizedBox(
              height: 5,
            ),
            CommandBubble(
              toDo: data['title'],
              location: data['location'],
              startTimeString: data['startTimeString'],
              endTimeString: data['endTimeString'],
              startTimeInt: data['startTimeInt'],
              endTimeInt: data['endTimeInt'],
              note: data['note'],
              status: data['status'],
              receiverUid: data['receiverId'],
              senderUid: data['senderId'],
              commandId: data['commandId'],
              commandRoomId: data['commandRoomId'],
            ),
          ],
        ),
      ),
    );
  }
}
