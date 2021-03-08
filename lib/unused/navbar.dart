/*
import 'package:flutter/material.dart';
 */

/*
class NavBar extends StatefulWidget {
  NavBar();

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: TextStyle(fontSize: 50),
    ),
    Text(
      'Index 1: Information',
      style: TextStyle(fontSize: 50),
    ),
    Text(
      'Index 2: Settings',
      style: TextStyle(fontSize: 50),
    ),
    Text(
      'Index 3: Leaderboard',
      style: TextStyle(fontSize: 50),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff47443F),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Information",

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: "Leaderboard"),
        ],
      ),
    );
  }
}

*/