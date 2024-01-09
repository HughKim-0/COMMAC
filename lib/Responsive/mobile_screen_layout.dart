import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: thirdColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 0 ? highlightColor : bottomBarNoHovering,
            ),
            backgroundColor: highlightColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.send,
              color: _page == 1 ? highlightColor : bottomBarNoHovering,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.forum,
              color: _page == 2 ? highlightColor : bottomBarNoHovering,
            ),
            backgroundColor: highlightColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
