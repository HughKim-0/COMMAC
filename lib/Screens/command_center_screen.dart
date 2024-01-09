import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Screens/alram_screen.dart';
import 'package:command_accepted/Screens/command_room_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommandCenterScreen extends StatefulWidget {
  const CommandCenterScreen({
    super.key,
  });

  @override
  State<CommandCenterScreen> createState() => _CommandCenterScreenState();
}

class _CommandCenterScreenState extends State<CommandCenterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Command Room',
              style: Theme.of(context).textTheme.displayLarge),
          centerTitle: true,
          backgroundColor: thirdColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlarmScreen(
                      receiverUserId: _auth.currentUser!.uid,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications,
                size: 32,
              ),
              color: highlightColor,
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: MediaQuery.of(context).size.width > miniTabletSize
              ? const EdgeInsets.only(right: 200, left: 200)
              : const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildMembersList(),
            ],
          ),
        ));
  }

  Widget _buildMembersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userMember')
          .doc(_auth.currentUser!.uid)
          .collection('member')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMemberListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMemberListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['emailAddress']) {
      return Card(
        color: secondaryColor,
        child: ListTile(
          title: Text(data['memberName'],
              style: Theme.of(context).textTheme.displayMedium),
          subtitle: Text(data['emailAddress'],
              style: Theme.of(context).textTheme.bodyLarge),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommandRoomScreen(
                  receiverUserId: data['memberId'],
                  receiverUserName: data['memberName'],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
