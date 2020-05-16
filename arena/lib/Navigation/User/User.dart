import 'package:arena/Authorization/main.dart';
import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/User/Book/BookStory.dart';
import 'package:arena/Navigation/User/Profile.dart';
import 'package:arena/Navigation/User/Settings.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'ProgramFeedback.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  Future test;
  String imageUrl;
  String name;
  String token;
  SharedPreferences preferences;
  FadeInImage fadeInImage;
  String ftToken;
  Future<String> getSharedPrefs() async {
    name = await getStringValuesSF("name");
    imageUrl = await getStringValuesSF("imageUrl");
    token = await refresh();
    ftToken = await getStringValuesSF("fbToken");
    print(token);
    if(imageUrl != null) {
      setState(() {
        fadeInImage = FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageUrl, fit: BoxFit.fill,height: 80, width: 80,);
      });
    }
    return token;
  }

  @override
  void initState() {
    super.initState();
    test = getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: test,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 16),
                child: Text("Отсутсвует соединение с интернетом"),
              );
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator()
              );
            default:
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(220.0),
                    child: Container(
                        padding: EdgeInsets.only(),
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                                // has the effect of softening the shadow
                                spreadRadius: 0.0,
                                // has the effect of extending the shadow
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
                            Container(
                              margin: EdgeInsets.only(left: 16.0, top: 27.0),
                              child: Row(
                                children: <Widget>[
                                  imageUrl == null ? Container(
                                    margin: EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 130, 130, 130),
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                    width: 80, height: 80,) :
                                  Center(child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: fadeInImage
                                  )
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child:
                                      Text(name == null ? "Пользователь" : name,
                                          style: new TextStyle(
                                              color: Color.fromARGB(
                                                  255, 79, 79, 79),
                                              fontSize: 18.0,
                                              fontFamily: 'Montserrat-Regular',
                                              fontWeight: FontWeight.bold)
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  body: WillPopScope(
                      child: SingleChildScrollView(
                        child: new Column(
                          children: <Widget>[
                            snapshot.data != null ? Button(
                              Icon(
                                CustomIcons.person,
                                color: Color.fromARGB(255, 47, 128, 237),
                              ),
                              " Редактировать профиль",
                            ) : Container(),
                            snapshot.data != null ? Button(
                                Icon(
                                  CustomIcons.reservation,
                                  color: Color.fromARGB(255, 47, 128, 237),
                                ),
                                " Забронировано") : Container(),
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
        });
  }
}


class Button extends StatefulWidget {
  Icon icon;
  String text;

  Button(this.icon, this.text);
  @override
  _ButtonState createState() => _ButtonState(icon, text);
}

class _ButtonState extends State<Button> {
  Icon icon;
  String text;
  bool isTap;

  _ButtonState(this.icon, this.text);

  @override
  void initState() {
    // TODO: implement initState
    isTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: isTap ? Color.fromARGB(255, 47, 128, 237) : Colors.white,
          width: double.infinity,
          height: 52,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Row(
            children: [
              Icon(icon.icon, color: isTap ? Colors.white : Color.fromARGB(255, 47, 128, 237),),
          Text(text,
                  style: TextStyle(
                      color: isTap ? Colors.white : Color.fromARGB(255, 79, 79, 79),
                      fontSize: 14.0,
                      fontFamily: 'Montserrat-Bold'))
            ],
          )),
      onTap: () async{
          setState(() {
            isTap = false;
          });
      },
      onTapCancel: () async{
        print("test");
        setState(() {
          isTap = false;
        });
      },
      onLongPress: () async{
        setState(() {
          isTap = true;
        });
      },

      onTapDown: (top) async {
        setState(() {
          isTap = true;
        });
      },

      onHorizontalDragStart:(drag) async{
        setState(() {
          isTap = false;
        });
      },

      onVerticalDragStart: (drag) async{
        setState(() {
          isTap = false;
        });
      },

      onTapUp: (top) async {
        setState(() {
          isTap = false;
        });
        if(text == " Напишите нам") {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedBack()),
          );
          setState(() {
            isTap = false;
          });
        }
        if(text == " Настройки")
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsWidget()),
          );
        if(text == " Редактировать профиль")
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileWidget()),
          );
        if(text == " Забронировано") {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookStory()),
          );
        }
        if(text == " Выход") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArenaApp()),
          );
        }
      },
    );
  }
}


//icon: Icon(icon.icon, color: isTap ? Colors.white : Color.fromARGB(255, 47, 128, 237),),
//              label: Text(text,
//                  style: TextStyle(
//                      color: isTap ? Colors.white : Color.fromARGB(255, 79, 79, 79),
//                      fontSize: 14.0,
//                      fontFamily: 'Montserrat-Bold')))
