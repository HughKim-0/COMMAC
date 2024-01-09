import 'package:flutter/material.dart';

class CommandBubble extends StatelessWidget {
  final String commandSender;
  final String toDo;
  final String? location;
  final String startTime;
  final String endTime;
  final String? note;
  final String status;

  final String receiverUid;

  const CommandBubble({
    super.key,
    required this.commandSender,
    required this.toDo,
    this.location,
    required this.startTime,
    required this.endTime,
    this.note,
    required this.status,
    required this.receiverUid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromRGBO(20, 58, 38, 0.612),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text('Sender:'),
                const SizedBox(width: 10),
                Text(commandSender),
              ],
            ),
            Row(
              children: [
                Text('To do:'),
                const SizedBox(width: 10),
                Text(toDo),
              ],
            ),
            Row(
              children: [
                Text('Location:'),
                const SizedBox(width: 10),
                Text(location!),
              ],
            ),
            Row(
              children: [
                Text('Start:'),
                const SizedBox(width: 10),
                Text(startTime),
              ],
            ),
            Row(
              children: [
                Text('End:'),
                const SizedBox(width: 10),
                Text(endTime),
              ],
            ),
            Row(
              children: [
                Text('Note:'),
                const SizedBox(width: 10),
                Text(note!),
              ],
            ),
            Row(
              children: [
                Text('Status:'),
                const SizedBox(width: 10),
                Text(status),
              ],
            ),
          ],
        ));
  }
}
