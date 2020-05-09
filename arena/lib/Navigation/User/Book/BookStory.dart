import 'dart:convert';
import 'dart:developer';

import 'package:arena/Authorization/main.dart';

import 'package:arena/Navigation/User/Book/BookPlace.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../Map.dart';
class BookStory extends StatefulWidget {
  @override
  _BookStoryState createState() => _BookStoryState();
}

Future<List<BookFresh>> fetchFresh() async {
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

Future<List<BookFresh>> fetchOld() async {
  List<BookFresh> fresh = new List<BookFresh>();
  var response;

  var token = await getStringValuesSF("accessToken");
  response = await getWithToken("http://217.12.209.180:8080/api/v1/booking/history");


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
  Future<List<BookFresh>> booksFresh;
  Future<List<BookFresh>> booksOld;
  List<BookWidget> booksWidget = new List<BookWidget>();
  List<BookWidget> booksWidgetOld = new List<BookWidget>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksFresh = fetchFresh();
    booksOld = fetchOld();
    initializeDateFormatting("ru", null);
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
              child: FutureBuilder<List<BookFresh>>(
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
                      for(BookFresh bk in snapshot.data) {
                        booksWidget.add(BookWidget(name: bk.place.name,
                          workTime:bk.place.workDayStartAt.toString().replaceRange(5, 8, "-")+bk.place.workDayEndAt.toString().replaceRange(5, 8, ""),
                          address: bk.place.address, bookings: bk.bookings,
                          date: DateFormat("dd MMMM yyyy").format(DateFormat("yyyy-MM-dd").parse(bk.date)), playground: bk.playground,));
                      }
                      return Container(
                          margin: EdgeInsets.only(bottom: 0.0),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: booksWidget
                          )));
                  }
                },
              ),
            ),
            Container(
              child: FutureBuilder<List<BookFresh>>(
                future: booksOld,
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
                      for(BookFresh bk in snapshot.data) {
                        booksWidgetOld.add(BookWidget(name: bk.place.name,
                          workTime:bk.place.workDayStartAt.toString().replaceRange(5, 8, "-")+bk.place.workDayEndAt.toString().replaceRange(5, 8, ""),
                          address: bk.place.address, bookings: bk.bookings,
                          date: DateFormat("dd MMMM yyyy").format(DateFormat("yyyy-MM-dd").parse(bk.date)), playground: bk.playground,));
                      }
                      return Container(
                          margin: EdgeInsets.only(bottom: 0.0),
                          color: Colors.white,
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: booksWidgetOld
                              )));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookWidget extends StatefulWidget {
  String name;
  String date;
  int i;
  Playground playground;
  String workTime;
  String address;
  List<Booking> bookings = List<Booking>();
  List<BookingsWidget> books = List<BookingsWidget>();
  BookWidget({this.name, this.workTime, this.address, this.bookings, this.date, this.playground});

  @override
  _BookWidgetState createState() => _BookWidgetState(name: name, workTime: workTime, date:date, address: address, bookings: bookings, playground: playground);
}

class _BookWidgetState extends State<BookWidget> {
  String name;
  String date;
  int i;
  Playground playground;
  String workTime;
  String address;
  List<Booking> bookings = List<Booking>();
  List<BookingsWidget> books = List<BookingsWidget>();
  _BookWidgetState({this.name, this.workTime, this.address, this.bookings, this.date, this.playground});


  @override
  void initState() {
    super.initState();
    books = List<BookingsWidget>();
    i = 0;
  }

  @override
  Widget build(BuildContext context) {
    for(Booking booking in bookings) {
      if(bookings.length > 1) {
        i++;
        books.add(BookingsWidget(date: date + " " + booking.bookingFrom.replaceRange(5, 8, "-")+ booking.bookingTo.replaceRange(5, 8, ""), isHalf: booking.half, price: booking.price.toString(), nameOfPlaygrounds: playground.sports["name"], number: i,));
      } else {books.add(BookingsWidget(date: date + " " + booking.bookingFrom.replaceRange(5, 8, "-") + booking.bookingTo.replaceRange(5, 8, ""), isHalf: booking.half, price: booking.price.toString(), nameOfPlaygrounds: playground.sports["name"], number: null,));}
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255,47, 128, 237))
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 16,),
      padding: EdgeInsets.only(left: 16, bottom: 16),
      child: Column(children: <Widget>[
        Container(margin: EdgeInsets.only(top: 16),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(name, style: TextStyle(color: Color.fromARGB(255,47, 128, 237), fontFamily: "Montserrat-Bold", fontSize: 24)),),
        Container(
          margin: EdgeInsets.only(left: 8, top: 16),
          child: Row(children: <Widget>[
            Text("Время работы:", style: TextStyle(color: Color.fromARGB(255,130, 130, 130), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),),
            Container(
                margin: EdgeInsets.only(left: 8),
                child:Text(workTime, style: TextStyle(color: Color.fromARGB(255,79, 79, 79), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),))
          ],),),
        Container(
          margin: EdgeInsets.only(left: 8, top: 8),
          child: Row(children: <Widget>[
            Text("Адрес площадки:", style: TextStyle(color: Color.fromARGB(255,130, 130, 130), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),),
            Container(
                margin: EdgeInsets.only(left: 8),
                child:Text(address, style: TextStyle(color: Color.fromARGB(255,79, 79, 79), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,fontSize: 14),))
          ],),),
        Container(
          margin: EdgeInsets.only(top: 16),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text("Вы забронировали:", style: TextStyle(color: Color.fromARGB(255,47, 128, 237), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 16)),),
        Container(margin: EdgeInsets.only(top: 0),
          child: Column(children: books,),)
      ],),
    );
  }
}



class BookingsWidget extends StatelessWidget {
  int number;
  bool isHalf;
  String nameOfPlaygrounds;
  String price;
  String date;
  BookingsWidget({this.number, this.isHalf, this.nameOfPlaygrounds, this.price, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 8, top: 8),
            child: Row(children: <Widget>[
              number == null ? Text("") : Container(margin: EdgeInsets.only(right: 3), child: Text(number.toString() + ")", style: TextStyle(color: Color.fromARGB(255,47, 128, 237), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 16),),),
              Text(isHalf ? "Половина площадки:" : "Площадка:" , style: TextStyle(color: Color.fromARGB(255,130, 130, 130), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),),
              Container(
                  margin: EdgeInsets.only(left: 8),
                  child:Text(nameOfPlaygrounds, style: TextStyle(color: Color.fromARGB(255,79, 79, 79), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,fontSize: 14),))
            ],),),
          Container(
            margin: EdgeInsets.only(left: 8, top: 8),
            child: Row(children: <Widget>[
              Text("Цена:" , style: TextStyle(color: Color.fromARGB(255,130, 130, 130), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),),
              Container(
                  margin: EdgeInsets.only(left: 8),
                  child:Text(price, style: TextStyle(color: Color.fromARGB(255,79, 79, 79), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,fontSize: 14),))
            ],),),
          Container(
            margin: EdgeInsets.only(left: 8, top: 8),
            child: Row(children: <Widget>[
              Text("Время:" , style: TextStyle(color: Color.fromARGB(255,130, 130, 130), fontFamily: "Montserrat-Regular",fontWeight: FontWeight.bold, fontSize: 14),),
              Container(
                  margin: EdgeInsets.only(left: 8),
                  child:Text(date, style: TextStyle(color: Color.fromARGB(255,79, 79, 79), fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,fontSize: 14),))
            ],),)
        ],
      ),
    );
  }
}
