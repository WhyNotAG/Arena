import 'package:arena/Authorization/main.dart';
import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:flutter/material.dart';

import 'ProgramFeedback.dart';

class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(220.0),
          child: TabBar(),
        ),
        body: WillPopScope(
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Button(
                    Icon(
                      CustomIcons.person,
                      color: Color.fromARGB(255, 47, 128, 237),
                    ),
                    " Редактировать профиль",
                  ),
                  Button(
                      Icon(
                        CustomIcons.reservation,
                        color: Color.fromARGB(255, 47, 128, 237),
                      ),
                      " Забронировано"),
                  Button(
                      Icon(
                        CustomIcons.ring,
                        color: Color.fromARGB(255, 47, 128, 237),
                      ),
                      " Уведомления"),
                  Button(
                      Icon(
                        CustomIcons.settings,
                        color: Color.fromARGB(255, 47, 128, 237),
                      ),
                      " Настройки"),
                  Button(
                      Icon(
                        CustomIcons.connect,
                        color: Color.fromARGB(255, 47, 128, 237),
                      ),
                      " Напишите нам"),
                  Button(
                    Icon(
                      CustomIcons.exit,
                      color: Color.fromARGB(255, 47, 128, 237),
                    ),
                    " Выход",
                  ),
                ],
              ),
            ),
            onWillPop: () async => false));
  }
}

class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(),
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 0.0, // has the effect of extending the shadow
                offset: Offset(
                  10.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                "Профиль",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Montserrat-Bold",
                ),
                textAlign: TextAlign.left,
              ),
              margin: EdgeInsets.only(top: 60.0, left: 20.0),
              width: double.infinity,
            ),
            TabBarPhoto(),
          ],
        ));
  }
}

class TabBarPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, top: 27.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.red,
            backgroundImage: AssetImage("assets/images/login.jpeg"),
            radius: 40,
          ),
          Container(
              margin: EdgeInsets.only(
                left: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  Text("Test",
                      style: new TextStyle(
                          color: Color.fromARGB(255, 79, 79, 79),
                          fontSize: 18.0,
                          fontFamily: 'Montserrat-Regular',
                          fontWeight: FontWeight.bold)),
                  Text("Test",
                      style: new TextStyle(
                          color: Color.fromARGB(255, 79, 79, 79),
                          fontSize: 18.0,
                          fontFamily: 'Montserrat-Regular',
                          fontWeight: FontWeight.bold))
                ],
              )),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  Icon icon;
  String text;

  Button(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: FlatButton.icon(
            padding: EdgeInsets.all(0.0),
              onPressed: () {
                if (text == " Выход")
                  Navigator.of(context).popUntil((route) => route.isFirst);
                if(text == " Напишите нам")
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedBack()),
                  );
              },
              icon: icon,
              label: Text(text,
                  style: TextStyle(
                      color: Color.fromARGB(255, 79, 79, 79),
                      fontSize: 14.0,
                      fontFamily: 'Montserrat-Bold')))),
      onTap: () {
        if (text == " Выход")
          Navigator.of(context).popUntil((route) => route.isFirst);
        if(text == " Напишите нам")
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedBack()),
          );
      },
    );
  }
}
