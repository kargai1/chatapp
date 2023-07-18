import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/recently_chats_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int value = 0;
  void _navBottomBar(int index) {
    setState(() {
      value = index;
    });
  }

  final List<Widget> _pageList = const [
    HomePage(),
    ConsversationsPage(),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[value],
      bottomNavigationBar: Container(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: GNav(
              padding: const EdgeInsets.all(16),
              tabBackgroundColor: Colors.white,
              gap: 8,
              backgroundColor: Theme.of(context).cardColor,
              color: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).cardColor,
              selectedIndex: value,
              onTabChange: _navBottomBar,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.chat_bubble, text: 'Chats'),
                GButton(icon: Icons.settings, text: 'Settings'),
              ]),
        ),
      ),
    );
  }
}
