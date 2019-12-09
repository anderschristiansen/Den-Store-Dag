import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home, size: 20),
              title: Text('Hjem')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gifts, size: 20),
              title: Text('Ønsker')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userCircle, size: 20),
              title: Text('Profile')),
      ].toList(),
      fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nuttin
            break;
          case 1:
            Navigator.pushNamed(context, '/about');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}