import 'package:command_accepted/Functions/auth_method.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Models/user.dart';
import 'package:command_accepted/Models/user_member.dart';
import 'package:command_accepted/Models/user_profile.dart';
import 'package:command_accepted/Screens/alram_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/global_variables.dart';
import 'package:command_accepted/Widgets/add_member_form.dart';
import 'package:command_accepted/Widgets/member_card_form.dart';
import 'package:command_accepted/Widgets/popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfile? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserMember> _members = [];
  List<COMMACUser> _users = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final notificationMethod = NotificationsService();

  @override
  void initState() {
    getInitValue();
    getMembers();
    super.initState();
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

  void getMembers() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await GeneralMethod().getMembers().then((members) {
      if (mounted) {
        setState(
          () {
            _members = members;
            _members.sort(
              (b, a) => b.memberName.toLowerCase().compareTo(
                    a.memberName.toLowerCase(),
                  ),
            );
          },
        );
      }
    });
  }

  void refresh() {
    getMembers();
  }

  void openAddMemberForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Popup(
          title: 'Add Member',
          content: AddMemberForm(refresh: refresh),
          width: 500,
        );
      },
    );
  }

  void singOut() {
    notificationMethod.deleteToken();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',
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
            ? const EdgeInsets.only(right: 150, left: 150)
            : const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(_user != null ? 'Hello, ${_user!.userName} ' : '',
                style: Theme.of(context).textTheme.headlineMedium),
            Text(_user != null ? '${_user!.emailAddress} ' : '',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 40,
            ),
            Text('Members', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(
              height: 5,
            ),
            for (var member in _members)
              Container(
                child: MemberCardForm(member: member),
                width: 380,
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
              ),
              onPressed: () async {
                openAddMemberForm();
              },
              child: Text('Add Member',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              indent: 150.0,
              endIndent: 150.0,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
              ),
              onPressed: () async {
                singOut();
              },
              child: Text('Sign Out',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
