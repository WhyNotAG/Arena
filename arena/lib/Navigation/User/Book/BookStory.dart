import 'dart:convert';
import 'dart:developer';

import 'package:arena/Navigation/User/Book/BookPlace.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class BookStory extends StatefulWidget {
  @override
  _BookStoryState createState() => _BookStoryState();
}

Future<List<BookFresh>> fetchFresh(BuildContext context) async {
  List<BookFresh> fresh = new List<BookFresh>();
  var response;

  var token = await getStringValuesSF("accessToken");
  response = await getWithToken("http://217.12.209.180:8080/api/v1/booking/booked");


  List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    List list = json.decode(response.body) as List;
    int length = list.length;
    log("test ${responseJson[0]}");
    for (int i = 0; i < length; i++) {
      log("arr ${BookFresh.fromJson(responseJson[0]).date}");
      fresh.add(BookFresh.fromJson(responseJson[i]));
    }
    log("test ${fresh.length}");
    return fresh;
  } else {
    throw Exception('Failed to load album');
  }
}


class _BookStoryState extends State<BookStory> {
  Future<List> booksFresh;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksFresh = fetchFresh(context);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Активные брони",  style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),),),
              Tab(child: Text("История бронирования",  style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130))),),
            ],
          ),
          title: Text('Забронированно', style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130))),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 130, 130, 130), //change your color here
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: FutureBuilder(
                future: booksFresh,
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){
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
                      log("res ${snapshot.data}");
                      return Container(
                          margin: EdgeInsets.only(bottom: 0.0),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[],
                          )));
                  }
                },
              ),
            ),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
