import 'dart:convert';

import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LostPassword extends StatefulWidget {
  @override
  _LostPasswordState createState() => _LostPasswordState();
}

class _LostPasswordState extends State<LostPassword> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( iconTheme: IconThemeData(
        color: Color.fromARGB(255, 130, 130, 130), //change your color here
      ),),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: double.infinity,
                        child: Text(
                          "Мы вышлем Вам новый пароль на указанный при регистрации Email/Телефон",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: "Montserrat-Bold",
                              fontSize: 24,
                              color: Color.fromARGB(255, 47, 128, 237)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        height: 56,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 79, 79, 79)),
                          minLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromARGB(255, 79, 79, 79),
                                    width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromARGB(255, 47, 128, 237),
                                    width: 1.0),
                              ),
                              hintText: "Email/Телефон",
                              hintStyle: TextStyle(
                                  fontFamily: "Montserrat-Regular",
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 130, 130, 130))),
                          onChanged: (value) {
                            setState(() async {
                              _name = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
                          border: Border.all(color: Color.fromARGB(255, 47, 128, 237)),
                          color: Colors.white,),
                        width: double.infinity, height: 56,
                        child: FlatButton(child: Text("Выслать новый пароль",
                          style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                              color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),
                          onPressed: () async {
                            var isEmail;
                            var response;
                            String p =
                                "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                            RegExp regExp = new RegExp(p);
                            String p2 =
                                "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}\$";
                            RegExp regExp2 = new RegExp(p2);
                            if (regExp2.hasMatch(_name)) isEmail = false;
                            else if (regExp.hasMatch(_name)) isEmail = true;
                            if(isEmail) {
                              response = await http.post("${server}account/reset-password/init",
                                  body: json.encode({"email": _name,}),
                                  headers: {"Content-type": "application/json",});
                            } else {
                              response = await http.post("${server}account/reset-password/init",
                                  body: json.encode({"phone":_name}),
                                  headers: {"Content-type": "application/json",});
                            }
                            print(_name);
                            print(response.statusCode);
                            print(response.body);
                            if (response.statusCode == 200) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ])
                )
            )
        )
    );
  }
}
