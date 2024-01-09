import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Responsive/mobile_screen_layout.dart';
import 'package:command_accepted/Responsive/responsive_layout_screen.dart';
import 'package:command_accepted/Responsive/tablet_screen_layout.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alarm extends StatefulWidget {
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String timeStamp;
  final String status;
  final String receiverId;
  final String receiverEmail;
  final String receiverName;
  final String alarmVersion;
  final String alarmId;

  const Alarm({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.status,
    required this.receiverId,
    required this.receiverEmail,
    required this.receiverName,
    required this.timeStamp,
    required this.alarmVersion,
    required this.alarmId,
  });

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  void addMember(uid, memberName, memberEmail, memberId) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await GeneralMethod()
        .addMember(uid, memberName, memberEmail, memberId)
        .then((value) {
      if (value == 'Success') {
        Fluttertoast.showToast(msg: 'Member has been successfully added');
      } else {
        Fluttertoast.showToast(msg: value);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void secondAddMember(uid, memberName, memberEmail, memberId) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await GeneralMethod()
        .addMember(uid, memberName, memberEmail, memberId)
        .then((value) {
      if (value == 'Success') {
      } else {
        Fluttertoast.showToast(msg: value);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void updateStatus(status) async {
    await GeneralMethod()
        .updateAlarmStatus(status, widget.receiverId, widget.alarmId);
    await GeneralMethod()
        .updateAlarmStatus(status, widget.senderId, widget.alarmId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alarmVersion == 'addMember') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          children: [
            (_auth.currentUser!.uid == widget.senderId)
                ? RichText(
                    text: TextSpan(
                        text:
                            'You sent a request to ${widget.receiverName} to be a member.  ',
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: <TextSpan>[
                          TextSpan(
                              text: '${widget.status}',
                              style: (widget.status == 'Pending')
                                  ? pendingFont
                                  : (widget.status == 'Accepted')
                                      ? acceptedFont
                                      : declinedFont)
                        ]),
                  )
                : RichText(
                    text: TextSpan(
                        text: '${widget.senderName}  ',
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: <TextSpan>[
                          TextSpan(text: 'wanted to add you as a member.')
                        ]),
                  ),
            (widget.status == 'Pending') &&
                    (_auth.currentUser!.uid != widget.senderId)
                ? Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () async {
                          addMember(uid, widget.senderName, widget.senderEmail,
                              widget.senderId);
                          secondAddMember(widget.senderId, widget.receiverName,
                              widget.receiverEmail, widget.receiverId);
                          updateStatus('Accepted');

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResponsiveLayout(
                                        mobileScreenLayout:
                                            MobileScreenLayout(),
                                        tabletScreenLayout:
                                            tabletScreenLayout(),
                                      )),
                              (Route<dynamic> route) => false);
                        },
                        child: Text('Accept',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () async {
                          updateStatus('Declined');
                        },
                        child: Text('Decline',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ],
                  )
                : (widget.status == 'Accepted') &&
                        (_auth.currentUser!.uid != widget.senderId)
                    ? Column(
                        children: [Text('Accpeted', style: acceptedFont)],
                      )
                    : (widget.status == 'Declined') &&
                            (_auth.currentUser!.uid != widget.senderId)
                        ? Column(
                            children: [Text('Declined', style: declinedFont)],
                          )
                        : Column(),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(16.0)),
        child: (_auth.currentUser!.uid != widget.senderId)
            ? Column(
                children: [
                  Text(widget.timeStamp),
                  Text(
                    'You got a command from ${widget.senderName}.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              )
            : Column(
                children: [
                  Text(widget.timeStamp),
                  Text(
                    'You sent a command to ${widget.receiverName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
      );
    }
  }
}
