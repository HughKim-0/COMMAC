import 'package:flutter/material.dart';

class BottomMenuBar extends StatefulWidget {
  const BottomMenuBar({super.key});

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit_document), label: 'Command'),
              BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Command'),
            ],
            selectedItemColor: Colors.amber[800],
            onTap: (int index) {},
          );
        },
      ),
    );
  }
}
