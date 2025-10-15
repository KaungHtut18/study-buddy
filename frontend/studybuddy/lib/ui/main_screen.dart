import 'package:flutter/material.dart';
import 'package:studybuddy/ui/home/chat_screen.dart';
import 'package:studybuddy/ui/home/home_screen.dart';
import 'package:studybuddy/ui/home/user_setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int myIndex = 1;
  List<Widget> pages = [
    const ChatScreen(),
    const HomeScreen(),
    const UserSetting(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Buddy',
          style: TextStyle(fontSize: 16, fontFamily: 'Teachers-R'),
        ),
      ),
      body: pages[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff30a7cc),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Teachers-R',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Teachers-R',
        ),
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Swiping'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
