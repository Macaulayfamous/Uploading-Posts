import 'package:chat_app_course/views/screens/pages/account_screen.dart';
import 'package:chat_app_course/views/screens/pages/home_screen.dart';
import 'package:chat_app_course/views/screens/pages/reals_screen.dart';
import 'package:chat_app_course/views/screens/pages/search_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    RealsScreen(),
    Center(
      child: Text('Commming Soon!!!!!'),
    ),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'SEARCH'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_call,
              ),
              label: 'REALS'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shop,
              ),
              label: 'SHOP'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'ACCOUNT'),
        ],
      ),
      body: Center(child: _pages[pageIndex]),
    );
  }
}
