import 'dart:async';
import 'dart:convert';

import 'package:arena/Navigation/Places/Place/Booking.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayScreen extends StatefulWidget {

  DateTime date;

  PayScreen({this.date});

  @override
  _PayScreenState createState() => _PayScreenState(date: date);
}

class _PayScreenState extends State<PayScreen> {
  String _name;
  DateTime date;

  _PayScreenState({this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30),
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
                  margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                  decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
                    color: Color.fromARGB(255, 47, 128, 237),),
                  width: double.infinity, height: 56,
                  child: FlatButton(child: Text("Сохранить изменения",
                    style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                        color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: () async {
                      var token = await getStringValuesSF("accessToken");
                      var id = await getIntValuesSF("id");
                      var expIn = await getIntValuesSF("expiredIn");

                      if( DateTime.fromMillisecondsSinceEpoch(expIn * 1000).isBefore(DateTime.now()))  {
                        token = await refresh();
                      }

                      var response = await postWithToken("http://217.12.209.180:8080/api/v1/booking/booking/", {"bookingsId": ids.toList(), "date": DateFormat("yyyy-MM-dd").format(date)});
                      dynamic responseJson = json.decode(response.body);
                      print(response.body);
                      print(response.statusCode);
                      ids = new Set();
                      print(responseJson["paymentUrl"]);
                      bool test = await Navigator.push(context,  MaterialPageRoute(builder: (context) => WebPage(url: responseJson["paymentUrl"])));
                      setState(() {
                        if (test) {
                          Navigator.pop(context, true);
                        }
                      });


                    },),),

              ],
            ),
          ),
        ),
      )
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

