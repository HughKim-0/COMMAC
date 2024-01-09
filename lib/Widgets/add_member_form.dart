import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:command_accepted/Functions/auth_method.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Models/user.dart';
import 'package:command_accepted/Models/user_profile.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AddMemberForm extends StatefulWidget {
  final Function() refresh;
  const AddMemberForm({super.key, required this.refresh});

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  UserProfile? _user;
  List<COMMACUser> _users = [];
  String searchTextTracker = '';
  bool _isShowUsers = false;
  List<COMMACUser> _searchedUsers = [];
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  COMMACUser? _searchedUser;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final notificationMethod = NotificationsService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getUsers();
    getInitValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void getInitValue() async {
    await AuthMethod().getUserInfo().then((UserProfile? user) async {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  void getUsers() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await GeneralMethod().getUsers().then(
      (users) {
        if (mounted) {
          setState(() {
            _users = users;
            _isLoading = false;
          });
        }
      },
    );
  }

  void sendAlarm(receiverName, receiverId, receiverEmail, receiverToken) async {
    final isValid = _formKey.currentState!.validate();
    String alarmVersion = 'addMember';
    String alarmId = const Uuid().v1();
    String status = 'Pending';
    String senderName = _user!.userName;

    if (!isValid) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    await notificationMethod.sendNotification(
      body: 'You got a new request to add a member',
      senderId: _auth.currentUser!.uid,
      receiverToken: receiverToken,
    );
    await GeneralMethod()
        .sendAlarm(
      receiverId,
      receiverEmail,
      receiverName,
      status,
      alarmId,
      alarmVersion,
      senderName,
    )
        .then((value) {
      if (value == 'Success') {
        Fluttertoast.showToast(msg: 'Request has been successfully sent');
        widget.refresh();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: value);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          widget.refresh();
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _searchController,
            style: Theme.of(context).textTheme.displaySmall,
            decoration: const InputDecoration(labelText: 'User email'),
            onFieldSubmitted: (String _) {
              setState(() {
                _isShowUsers = true;
              });
            },
          ),
          _isShowUsers
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('emailAddress', isEqualTo: _searchController.text)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['userName'],
                                    style: searchSmallFont,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['emailAddress'],
                                    style: searchSmallFont,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: blueColor,
                                      ),
                                      onPressed: () => sendAlarm(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['userName'],
                                        (snapshot.data! as dynamic).docs[index]
                                            ['uid'],
                                        (snapshot.data! as dynamic).docs[index]
                                            ['emailAddress']!,
                                        (snapshot.data! as dynamic).docs[index]
                                            ['token']!,
                                      ),
                                      child: Text('Add',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              : Text(
                  'Type email address and enter',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ],
      ),
    );
  }
}
