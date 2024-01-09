import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Models/user_member.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Widgets/popup.dart';
import 'package:flutter/material.dart';

class MemberCardForm extends StatefulWidget {
  final UserMember member;

  const MemberCardForm({
    super.key,
    required this.member,
  });

  @override
  State<MemberCardForm> createState() => _MemberCardFormState();
}

class _MemberCardFormState extends State<MemberCardForm> {
  UserMember? _member;

  @override
  void initState() {
    setMember();
    super.initState();
  }

  void deleteMember(String memberId) async {
    await GeneralMethod().deleteMember(memberId).then(
      (value) {
        Navigator.pop(context);
      },
    );
  }

  void setMember() {
    setState(() {
      _member = widget.member;
    });
  }

  void refresh() {}

  void openConfirmDeleteMemberPopUp(String memberId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Popup(
            title: 'Delete Member',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'This can\'t be undone. Do you want to delete?',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => deleteMember(memberId),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete Member'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Colse'),
                    ),
                  ],
                )
              ],
            ),
            width: 500,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: secondaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_member!.memberName,
                style: Theme.of(context).textTheme.displayMedium),
            Text(_member!.memberEmail,
                style: Theme.of(context).textTheme.bodyLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      openConfirmDeleteMemberPopUp(_member!.memberId),
                  child: Text(
                    'Delete',
                    style: deleteSmallFont,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
