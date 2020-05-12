import 'dart:async';
import 'dart:convert';

import 'package:arena/Navigation/Places/Place/Booking.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayScreen extends StatefulWidget {

  DateTime date;

  PayScreen({this.date});

  @override
  _PayScreenState createState() => _PayScreenState(date: date);
}

class _PayScreenState extends State<PayScreen> {
  String _name;
  String _infoCheck;
  DateTime date;

  _PayScreenState({this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      onHorizontalDragCancel: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:30),
                      width: double.infinity,
                      child: Text("Введите ваши данные", textAlign: TextAlign.left,  style: TextStyle(fontFamily: "Montserrat-Bold",
                          fontSize: 24, color: Color.fromARGB(255,47, 128, 237)),),),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 100),
                      child: Text("Имя", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                          fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255,47, 128, 237))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 56,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "Montserrat-Regular",
                            fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                        minLines: 1,
                        decoration: InputDecoration(border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 1.0),
                        ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 1.0),),
                            hintText: "Имя",
                            hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                                fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                        onChanged: (value){
                          setState(() async {
                            _name = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 30),
                      child: Text("Email или телефон, куда мы вышлем чек", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                          fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255,47, 128, 237))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 56,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "Montserrat-Regular",
                            fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                        minLines: 1,
                        decoration: InputDecoration(border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 1.0),
                        ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 1.0),),
                            hintText: "Email/телефон",
                            hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                                fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                        onChanged: (value){
                          setState(() async {
                            _infoCheck = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 100),
                      decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
                        color: Color.fromARGB(255, 47, 128, 237),),
                      width: double.infinity, height: 56,
                      child: FlatButton(child: Text("Оплатить",
                        style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                            color: Colors.white, fontWeight: FontWeight.bold),),
                        onPressed: () async {
                          var token = await getStringValuesSF("accessToken");
                          var id = await getIntValuesSF("id");
                          var expIn = await getIntValuesSF("expiredIn");

                          if( DateTime.fromMillisecondsSinceEpoch(expIn * 1000).isBefore(DateTime.now()))  {
                            token = await refresh();
                          }

                          var isEmail;
                          String p =
                              "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                          RegExp regExp = new RegExp(p);

                          String p2 =
                              "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}\$";
                          RegExp regExp2 = new RegExp(p2);
                          if (regExp2.hasMatch(_infoCheck)) isEmail = false;
                          else if (regExp.hasMatch(_infoCheck)) isEmail = true;

                          var response;
                          if (_name != null && _infoCheck != null) {
                            if(token != null) {
                              if(isEmail) {
                                response = await postWithToken("${server}booking/booking/", {"bookingsId": ids.toList(), "name": _name,
                                  "email": _infoCheck, "date": DateFormat("yyyy-MM-dd").format(date)});
                              } else {
                                response = await postWithToken("${server}booking/booking/", {"bookingsId": ids.toList(), "name": _name,
                                  "phone": _infoCheck, "date": DateFormat("yyyy-MM-dd").format(date)});
                              }
                            } else {
                              if(isEmail) {
                                response = await http.post("${server}booking/booking/",
                                    body: json.encode({"bookingsId": ids.toList(), "date": DateFormat("yyyy-MM-dd").format(date),"name": _name,
                                      "email": _infoCheck,}),
                                    headers: {"Content-type": "application/json",});
                              } else {
                                response = await http.post("${server}booking/booking/",
                                    body: json.encode({"bookingsId": ids.toList(), "date": DateFormat("yyyy-MM-dd").format(date), "name": _name,
                                      "phone": _infoCheck,}),
                                    headers: {"Content-type": "application/json",});
                              }
                            }
                            dynamic responseJson = json.decode(response.body);
                            ids = new Set();
                            if(response.statusCode == 200) {
                              bool test = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      WebPage(url: responseJson["paymentUrl"])));
                              setState(() {
                                if (test) {
                                  Navigator.pop(context, true);
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}




class WebPage extends StatefulWidget {
  String url;

  WebPage({this.url});

  @override
  _WebPageState createState() => _WebPageState(url: url);
}

class _WebPageState extends State<WebPage> {
  String url;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  _WebPageState({this.url});

  @override
  Widget build(BuildContext context) {
    print(url);
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, true);
          },
        ),),
        body: Container(
            child: WebView(initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                }))
    );
  }
}

