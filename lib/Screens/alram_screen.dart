import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Widgets/alarm.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  final String receiverUserId;
  const AlarmScreen({super.key, required this.receiverUserId});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm', style: Theme.of(context).textTheme.displayLarge),
        centerTitle: true,
        backgroundColor: thirdColor,
      ),
      body: Container(
        color: primaryColor,
        child: Column(
          children: [
            Expanded(
              child: _buildAlarmList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmList() {
    return StreamBuilder(
      stream: GeneralMethod().getAlarms(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildAlarmItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildAlarmItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Alarm(
              senderId: data['senderId'],
              senderEmail: data['senderEmail'],
              senderName: data['senderName'],
              timeStamp: data['timeStamp'],
              status: data['status'],
              receiverId: data['receiverId'],
              receiverEmail: data['receiverEmail'],
              receiverName: data['receiverName'],
              alarmVersion: data['alarmVersion'],
              alarmId: data['alarmId'],
            )
          ],
        ),
      ),
    );
  }
}
