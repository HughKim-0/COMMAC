import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommandBubble extends StatefulWidget {
  final String toDo;
  final String? location;
  final String startTimeString;
  final String endTimeString;
  final int startTimeInt;
  final int endTimeInt;
  final String? note;
  final String status;
  final String receiverUid;
  final String senderUid;
  final String commandId;
  final String commandRoomId;

  const CommandBubble({
    super.key,
    required this.toDo,
    this.location,
    required this.startTimeString,
    required this.endTimeString,
    required this.startTimeInt,
    required this.endTimeInt,
    this.note,
    required this.status,
    required this.receiverUid,
    required this.senderUid,
    required this.commandId,
    required this.commandRoomId,
  });

  @override
  State<CommandBubble> createState() => _CommandBubbleState();
}

class _CommandBubbleState extends State<CommandBubble> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static DateTime _convertedStartTime = DateTime.now();
  static DateTime _convertedEndTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void convertStartTimeInt(startTimeInt) async {
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(startTimeInt);
    setState(() {
      _convertedStartTime = startTime;
    });
  }

  void convertEndTimeInt(endTimeInt) async {
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeInt);
    setState(() {
      _convertedEndTime = endTime;
    });
  }

  void updateStatus(status) async {
    await GeneralMethod()
        .updateCommandStatus(status, widget.commandRoomId, widget.commandId);
  }

  Event buildEvent({Recurrence? recurrence}) {
    return Event(
      title: widget.toDo,
      description: widget.note!,
      location: widget.location!,
      startDate: _convertedStartTime,
      endDate: _convertedEndTime,
      allDay: false,
      iosParams: const IOSParams(
        reminder: Duration(minutes: 40),
        url: "http://example.com",
      ),
      androidParams: const AndroidParams(
        emailInvites: ["test@example.com"],
      ),
      recurrence: recurrence,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: (widget.senderUid != _auth.currentUser!.uid)
            ? secondaryColor
            : myBubbleColor,
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
                text: 'To do:  ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: '${widget.toDo}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Location:  ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: '${widget.location}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'From:  ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: '${widget.startTimeString}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'To:  ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: '${widget.endTimeString}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Note:  ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: '${widget.note}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Status:  ',
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
          ),
          (widget.senderUid != _auth.currentUser!.uid) &&
                  (widget.status != 'Accepted' && widget.status != 'Declined')
              ? Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                      ),
                      onPressed: () async {
                        convertStartTimeInt(widget.startTimeInt);
                        convertEndTimeInt(widget.endTimeInt);
                        Add2Calendar.addEvent2Cal(buildEvent());
                        updateStatus('Accepted');
                      },
                      child: Text('Accept',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                      ),
                      onPressed: () async {
                        updateStatus('Declined');
                      },
                      child: Text('Decline',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                )
              : Column(),
        ],
      ),
    );
  }
}
