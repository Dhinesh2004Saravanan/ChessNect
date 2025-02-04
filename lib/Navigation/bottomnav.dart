import 'package:chess_application_1/screens/homePage.dart';
import 'package:chess_application_1/screens/profilePage.dart';
import 'package:chess_application_1/screens/savedPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Utils/Constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.NSwhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: Screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        backgroundColor: TColors.NSwhite,
        currentIndex: _selectedIndex,
        selectedItemColor: TColors.buttombaricon,
        unselectedItemColor: TColors.iconhint,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              _selectedIndex == 1
                  ? FontAwesomeIcons.solidBookmark
                  : FontAwesomeIcons.bookmark,
              size: 20,
              color: _selectedIndex == 1
                  ? TColors.buttombaricon
                  : TColors.iconhint,
            ),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              _selectedIndex == 2
                  ? FontAwesomeIcons.solidUser
                  : FontAwesomeIcons.user,
              size: 20,
              color: _selectedIndex == 2
                  ? TColors.buttombaricon
                  : TColors.iconhint,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Widget> Screens = [NewsPage(), Savedpage(), Profilepage()];
}
