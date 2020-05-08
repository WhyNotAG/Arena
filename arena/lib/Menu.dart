import 'package:arena/Navigation/Favourite.dart';
import 'package:arena/Navigation/Places/Places.dart';
import 'package:arena/Navigation/User/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/Map.dart';

class MenuScreen extends StatefulWidget {
  int _currentIndex;

  MenuScreen(this._currentIndex);

  @override
  _MenuScreenState createState() => _MenuScreenState(_currentIndex);
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex;


  _MenuScreenState(this._currentIndex);

  final List<Widget> _children = [
    MapSample(),
    Places(),
    Favourites(),
    User(),
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
        backgroundColor: Colors.white,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 47, 128, 237),
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.map_1,),
              title: new Text("Карта",
                style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center,)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.field,),
              title: new Text(" Площадки",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.star,),
              title: new Text("Избранное",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.person,),
              title: new Text("Профиль",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          )
        ],
      ),
    );
  }
}
