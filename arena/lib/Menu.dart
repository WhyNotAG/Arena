import 'package:arena/Navigation/Places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    Places(),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.indigoAccent)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 47, 128, 237),
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedItemColor: Colors.black,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.map,),
              title: new Text("Карта",
                style: TextStyle(color: Colors.black),)
          ),

          BottomNavigationBarItem(
              icon: new Icon(Icons.spa,),
              title: new Text("Площадки",
                style: TextStyle(color: Colors.black),)
          ),

          BottomNavigationBarItem(
              icon: new Icon(Icons.star_border,),
              title: new Text("Избранное",
                style: TextStyle(color: Colors.black),)
          ),

          BottomNavigationBarItem(
              icon: new Icon(Icons.person,),
              title: new Text("Профиль",
                style: TextStyle(color: Colors.black),)
          )
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
