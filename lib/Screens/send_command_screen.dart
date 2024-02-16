import 'package:command_accepted/Functions/auth_method.dart';
import 'package:command_accepted/Functions/general_method.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Models/user_command.dart';
import 'package:command_accepted/Models/user_member.dart';
import 'package:command_accepted/Models/user_profile.dart';
import 'package:command_accepted/Screens/alram_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/global_variables.dart';
import 'package:command_accepted/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class SendCommandScreen extends StatefulWidget {
  const SendCommandScreen({super.key});

  @override
  State<SendCommandScreen> createState() => _SendCommandScreenState();
}

class _SendCommandScreenState extends State<SendCommandScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<UserMember> _members = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final List<BridgeCommandedMember> _bridgeMembers = [BridgeCommandedMember()];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(const Duration(hours: 1));
  String _startTimeString = '';
  String _endTimeString = '';
  final String _status = 'Pending';
  int startTimeInt = 0;
  int endTimeInt = 0;
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();
  late PageController pageController;

  UserProfile? _user;
  final notificationMethod = NotificationsService();
  static final notifications = NotificationsService();

  @override
  void initState() {
    getMembers();
    getInitValue();
    setState(() => _startTimeString = datetimeToString(startDateTime));
    setState(() => _endTimeString = datetimeToString(endDateTime));
    startTimeStampToInt(startDateTime);
    endTimeStampToInt(endDateTime);

    notificationMethod.firebaseNotification(context);
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
        setState(() {
          _members = members;
          _members.sort(
            (b, a) => b.memberName.toLowerCase().compareTo(
                  a.memberName.toLowerCase(),
                ),
          );
        });
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  void startTimeStampToInt(DateTime timeStamp) async {
    setState(() {
      startTimeInt = timeStamp.millisecondsSinceEpoch;
    });
  }

  void endTimeStampToInt(DateTime timeStamp) async {
    setState(() {
      endTimeInt = timeStamp.millisecondsSinceEpoch;
    });
  }

  void sendCommand(member, receiverToken) async {
    String commandId = const Uuid().v1();
    if (_titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please type command title');
    } else {
      await notificationMethod.sendNotification(
        body: 'You got a new command',
        senderId: _auth.currentUser!.uid,
        receiverToken: receiverToken,
      );
      await GeneralMethod()
          .sendCommand(
              member.memberId!,
              _titleController.text,
              _locationController.text,
              startTimeInt,
              endTimeInt,
              _noteController.text,
              _status,
              _startTimeString,
              _endTimeString,
              commandId)
          .then((value) {
        if (value == 'Success') {
          Fluttertoast.showToast(msg: 'Command has been successfully sent');
          reset();
        } else {
          Fluttertoast.showToast(msg: value);
        }
      });
    }
  }

  void singOut() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
  }

  void sendAlarm(receiverName, receiverId, receiverEmail) async {
    String alarmVersion = 'sendCommand';
    String alarmId = const Uuid().v1();
    String status = 'Pending';
    String senderName = _user!.userName;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
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

  void resetTwo() {
    pageController.jumpToPage(1);
  }

  void reset() {
    _titleController.clear();
    _locationController.clear();
    _noteController.clear();
    _bridgeMembers.clear();
    setState(
      () {
        _bridgeMembers.add(
          BridgeCommandedMember(
            memberId: null,
            memberName: null,
            memberEmail: null,
            memberPhone: null,
          ),
        );
      },
    );
    _formKey.currentState?.setState(() {});
    ;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startHours = startDateTime.hour.toString().padLeft(2, '0');
    final startMinutes = startDateTime.minute.toString().padLeft(2, '0');
    final endHours = endDateTime.hour.toString().padLeft(2, '0');
    final endMinutes = endDateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Command',
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
              height: 50,
            ),
            Text('Receiver', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _bridgeMembers.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ListTile(
                        title: Text(
                            _bridgeMembers[index].memberName.toString() ==
                                    "null"
                                ? "Choose a member below"
                                : _bridgeMembers[index].memberName.toString()),
                      ),
                    ),
                    if (index > 0)
                      const Expanded(
                        child: SizedBox(
                          width: 20,
                        ),
                      ),
                    if (index > 0)
                      Expanded(
                        child: InkWell(
                          child: const Icon(
                            Icons.backspace,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              _bridgeMembers.removeAt(index);
                            });
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _bridgeMembers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          key: _formKey,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: highlightColor,
                            size: 35,
                          ),
                          isExpanded: true,
                          value: _bridgeMembers[index].memberId,
                          style: Theme.of(context).textTheme.displaySmall,
                          onChanged: (newValue) {
                            setState(() {
                              _bridgeMembers[index].memberId = newValue!;
                            });
                          },
                          items: _members.map((member) {
                            return DropdownMenuItem<String>(
                              value: member.memberId,
                              child: Row(
                                children: [
                                  Text(member.memberName),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(('(${member.memberEmail})')),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _bridgeMembers[index].memberId =
                                      member.memberId;
                                  _bridgeMembers[index].memberName =
                                      member.memberName;
                                  _bridgeMembers[index].memberEmail =
                                      member.memberEmail;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _bridgeMembers[0].memberId != null
                ? _bridgeMembers[_bridgeMembers.length - 1].memberId != null
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            greenColor,
                          ),
                          elevation: MaterialStateProperty.all<double>(
                            5.0,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _bridgeMembers.add(
                                BridgeCommandedMember(
                                  memberId: null,
                                  memberName: null,
                                  memberEmail: null,
                                  memberPhone: null,
                                ),
                              );
                            },
                          );
                        },
                        child: Text('Add',
                            style: Theme.of(context).textTheme.displaySmall),
                      )
                    : SizedBox(
                        height: 5,
                      )
                : SizedBox(
                    height: 5,
                  ),
            const SizedBox(
              height: 20,
            ),
            Text('Command Title',
                style: Theme.of(context).textTheme.displayLarge),
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.displaySmall,
              decoration: InputDecoration(
                hintText: 'Type title here',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Location', style: Theme.of(context).textTheme.displayLarge),
            TextField(
              controller: _locationController,
              style: Theme.of(context).textTheme.displaySmall,
              decoration: InputDecoration(
                hintText: 'Type location here',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('From', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      final date = await pickStartDate();
                      if (date == null) return;
                      setState(() => startDateTime = date);
                      print(startDateTime);
                    },
                    child: Text(
                        '${startDateTime.year}/${startDateTime.month}/${startDateTime.day}',
                        style: dateFont),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        lightPrimaryColor,
                      ),
                      elevation: MaterialStateProperty.all<double>(
                        5.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        lightPrimaryColor,
                      ),
                      elevation: MaterialStateProperty.all<double>(
                        5.0,
                      ),
                    ),
                    onPressed: () async {
                      final time = await pickStartTime();
                      if (time == null) return;

                      final startDateWithTime = DateTime(
                        startDateTime.year,
                        startDateTime.month,
                        startDateTime.day,
                        time.hour,
                        time.minute,
                      );
                      setState(() => startDateTime = startDateWithTime);
                      setState(() =>
                          _startTimeString = datetimeToString(startDateTime));
                      setState(() {
                        startTimeStampToInt(startDateTime);
                      });
                    },
                    child: Text('$startHours:$startMinutes',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text('To', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(width: 52),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        lightPrimaryColor,
                      ),
                      elevation: MaterialStateProperty.all<double>(
                        5.0,
                      ),
                    ),
                    onPressed: () async {
                      final date = await pickEndDate();
                      if (date == null) return;
                      setState(() => endDateTime = date);
                      print(endDateTime);
                    },
                    child: Text(
                        '${endDateTime.year}/${endDateTime.month}/${endDateTime.day}',
                        style: dateFont),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        lightPrimaryColor,
                      ),
                      elevation: MaterialStateProperty.all<double>(
                        5.0,
                      ),
                    ),
                    onPressed: () async {
                      final endTime = await pickEndTime();
                      if (endTime == null) return;

                      final endDateWithTime = DateTime(
                        endDateTime.year,
                        endDateTime.month,
                        endDateTime.day,
                        endTime.hour,
                        endTime.minute,
                      );
                      setState(() => endDateTime = endDateWithTime);
                      setState(
                          () => _endTimeString = datetimeToString(endDateTime));
                      setState(() {
                        endTimeStampToInt(endDateTime);
                      });
                      print(endDateTime);
                      print(endTimeInt);
                    },
                    child: Text('$endHours:$endMinutes',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Note', style: Theme.of(context).textTheme.displayLarge),
            TextField(
              controller: _noteController,
              maxLines: 5,
              style: Theme.of(context).textTheme.displaySmall,
              decoration: InputDecoration(
                hintText: 'Type note here',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 180, 180, 180)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
              ),
              onPressed: () async {
                if (_bridgeMembers[0].memberName == null) {
                  Fluttertoast.showToast(
                      msg: 'Please choose members to send a command');
                } else {
                  for (var member in _bridgeMembers) {
                    await notificationMethod
                        .getReceiverToken(member.memberId)
                        .then((value) {
                      sendCommand(member, value);
                    });
                    sendAlarm(
                        member.memberName, member.memberId, member.memberEmail);
                  }
                }
              },
              child: Text('Send',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickStartDate() => showDatePicker(
        context: context,
        initialDate: startDateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2200),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  overline: TextStyle(fontSize: 10),
                ),
              ),
              child: child!);
        },
      );

  Future<TimeOfDay?> pickStartTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute),
      );

  Future<DateTime?> pickEndDate() => showDatePicker(
        context: context,
        initialDate: endDateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2200),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  overline: TextStyle(fontSize: 10),
                ),
              ),
              child: child!);
        },
      );

  Future<TimeOfDay?> pickEndTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute),
      );
}
