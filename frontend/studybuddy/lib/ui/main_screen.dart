import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/home/chat_screen.dart';
import 'package:studybuddy/ui/home/home_screen.dart';
import 'package:studybuddy/ui/home/user_setting.dart';
import 'package:studybuddy/services/match_notifier_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int myIndex = 1;

  final _matchService = MatchNotifierService();
  List<Widget> pages = [const ChatScreen(), HomeScreen(), const UserSetting()];

  @override
  void initState() {
    super.initState();
    _initializeMatchNotifier();
  }

  Future<void> _initializeMatchNotifier() async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    // Add a small delay to ensure context is ready
    await Future.delayed(const Duration(milliseconds: 100));
    
    _matchService.start((count) {
      serviceProvider.setMatchedCount(count);
    }, serviceProvider.userId);
  }

  @override
  void dispose() {
    _matchService.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          myIndex == 0
              ? IconButton(
                padding: const EdgeInsets.only(right: 16.0),
                icon: const Icon(Icons.search, color: Colors.blue, size: 28),
                onPressed: () {},
              )
              : SizedBox(),
        ],
        title: const Text(
          'StudyBuddy',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff30a7cc),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontFamily: 'Teachers-R'),
        unselectedLabelStyle: TextStyle(fontFamily: 'Teachers-R'),
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
