import 'package:arena/Navigation/Places/Place/PayScreen.dart';
import 'package:flutter/material.dart';

import '../Menu.dart';

class Politics extends StatefulWidget {
  @override
  _PoliticsState createState() => _PoliticsState();
}

class _PoliticsState extends State<Politics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Нажимая на кнопку 'Войти' Вы принимаете нашу", style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: "Montserrat-Regular",)),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 14,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => WebPage(url: "https://arenasport.me/polconf.pdf",)),);
                            },
                            child:  Container(
                              margin: EdgeInsets.only(left: 4),
                              height: 14,
                              alignment: Alignment.topLeft,
                              child: new Text(
                                  "политику конфиденциальности",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline, fontSize: 12.0,
                                      fontFamily: "Montserrat-Regular",
                                      color: Color.fromARGB(255, 47, 128, 237))
                              ),
                            ),
                          ),
                          Text(" и", style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Montserrat-Regular",))
                        ],),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => WebPage(url: "https://arenasport.me/polsogl.pdf",)),);
                      },
                      child:  Container(
                        margin: EdgeInsets.only(left: 4),
                        height: 14,
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        child: new Text(
                            "пользовательское соглашение",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline, fontSize: 12.0,
                                fontFamily: "Montserrat-Regular",
                                color: Color.fromARGB(255, 47, 128, 237))
                        ),
                      ),
                    ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: FlatButton(child: new Text("Войти",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: "Montserrat-Bold")
                  ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen(0)),);
                    },
                  ),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(30.0),
                      color: Color.fromARGB(255, 47, 128, 237)
                  ),
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 21.0),
                )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
