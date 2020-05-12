import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/Places/Place/PayScreen.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Place.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

Set<String> ids = new Set<String>();

class Book {
  int id;
  bool isHalfBookingAvailable;
  double price;
  bool isBooked;
  String to;
  String from;

  Book(
      {this.id,
      this.isHalfBookingAvailable,
      this.price,
      this.isBooked,
      this.to,
      this.from});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json["id"] as int,
        isHalfBookingAvailable: json["isHalfBookingAvailable"] as bool,
        price: json["price"] as double,
        isBooked: json["isBooked"] as bool,
        to: json["to"] as String,
        from: json["from"] as String);
  }
}

Future<List<Book>> fetchTime(int id, DateTime time, bool isHalf) async {
  List times = List();
  var response;

  var updateTime = DateFormat("y-MM-dd").format(time);

  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken(
      "${server}booking/${id}?date=${updateTime}",
    );
  } else {
    response = await http.get(
        '${server}booking/${id}?date=${updateTime}',
        headers: {"Content-type": "application/json"});
  }

  Map<String, dynamic> responseJson =
      json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    var list = responseJson["bookings"] as List;
    List<Book> pl = list.map((i) => Book.fromJson(i)).toList();
    List<Book> result = List();

    for(Book book in pl) {
      if (book.isHalfBookingAvailable = isHalf) {
        result.add(book);
      }
    }

    return result;
  } else {
    throw Exception('Failed to load album');
  }
}

class Booking extends StatefulWidget {
  int id;
  Booking(this.id);
  @override
  _BookingState createState() => _BookingState(id);
}

class _BookingState extends State<Booking> {
  int id;
  DateTime date;

  _BookingState(this.id);

  Future<Place> place;
  Future<List<Book>> timeWidgets;
  Playground selectedPlayground;
  bool isHalf = false;

  @override
  void initState() {
    date = DateTime.now();
    ids = new Set<String>();
    place = fetchPlace(id).then((value){

      selectedPlayground = value.playgrounds[0];
      setState(() {
        timeWidgets = fetchTime(value.playgrounds[0].id, date, isHalf);
      });
      return value;
    });

    initializeDateFormatting("ru", null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Place>(
          future: place,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        child: SliverSafeArea(
                          top: false,
                          bottom: false,
                          sliver: SliverAppBar(
                              actions: <Widget>[
                                IconButton(
                                  onPressed: (){
                                    DatePicker.showDatePicker(context,
                                      minTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().month),
                                      onConfirm: (tecDate) {
                                       setState(() {
                                         date = tecDate;
                                         timeWidgets = fetchTime(selectedPlayground.id, date, isHalf);
                                       });
                                      },
                                        currentTime: DateTime.now(), locale: LocaleType.ru
                                    );
                                  },
                                  icon: Icon(
                                    CustomIcons.day,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(right: 21.0),
                                )
                              ],
                              leading: IconButton(
                                icon: Icon(
                                  CustomIcons.arrowBack,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              expandedHeight: 285.0,
                              floating: false,
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                centerTitle: true,
                                background: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Center(
                                        child: Stack(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Center(
                                                child: Container(
                                              child: SizedBox(
                                                  child:
                                                      CircularProgressIndicator(),
                                                  width: 30,
                                                  height: 30),
                                            )),
                                            new Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image: snapshot
                                                            .data
                                                            .customImages[0]
                                                            .fullImage,
                                                        fit: BoxFit.fill)),
                                          ],
                                        ),
                                        Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(top: 110),
                                            height: 100,
                                            color: Colors.black.withAlpha(50),
                                            padding: EdgeInsets.only(top: 15),
                                            child: Text(
                                              snapshot.data.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 80),
                                          height: 48,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  setPlaceIcon(snapshot.data)),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                              ),
                              bottom: PreferredSize(
                                child: Container(
                                  height: 156,
                                  width: double.infinity,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  70, 130, 130, 130),
                                              blurRadius: 10.0,
                                              // has the effect of softening the shadow
                                              spreadRadius: 0.0,
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0.0,
                                                // horizontal, move right 10
                                                10.0, // vertical, move down 10
                                              ),
                                            )
                                          ]),
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        DateFormat(
                                                                "dd MMMM, EEEE")
                                                            .format(date),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat-Bold",
                                                          color: Color.fromARGB(
                                                              255, 79, 79, 79),
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                            DateFormat("dd MMM")
                                                                .format(date.add(
                                                                    Duration(
                                                                        days:
                                                                            1))),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Montserrat-Regular",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      47,
                                                                      128,
                                                                      237),
                                                              fontSize: 12,
                                                            )),
                                                        Container(
                                                          child: Transform(
                                                            alignment: Alignment
                                                                .center,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                CustomIcons
                                                                    .arrowBack,
                                                                size: 11,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        47,
                                                                        128,
                                                                        237),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  ids = new Set();
                                                                  date = date.add(
                                                                      Duration(
                                                                          days:
                                                                          1));
                                                                  print(date);
                                                                  timeWidgets = fetchTime(selectedPlayground.id, date, isHalf);
                                                                });
                                                              },
                                                            ),
                                                            transform: Matrix4
                                                                .rotationY(
                                                                    math.pi),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                            "Половина\nплощадки",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Montserrat-Regular",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      79,
                                                                      79,
                                                                      79),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            )),
                                                        Transform.scale(
                                                          child:
                                                              CupertinoSwitch(
                                                            value: isHalf,

                                                            activeColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    47,
                                                                    128,
                                                                    237),
                                                                onChanged: (bool value) {
                                                                 setState(() {
                                                                   isHalf = !isHalf;
                                                                   timeWidgets = fetchTime(selectedPlayground.id, date, isHalf);
                                                                 });
                                                                },
                                                          ),
                                                          scale: 0.7,
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      child: Theme(
                                                        data: ThemeData(
                                                            canvasColor:
                                                                Colors.white),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                              focusColor:
                                                                  Colors.white,
                                                              iconSize: 24,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Montserrat-Regular",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          130,
                                                                          130,
                                                                          130)),
                                                              //elevation: 22,
                                                              value:
                                                                  selectedPlayground,
                                                              onChanged:
                                                                  (Playground
                                                                      newValue) {
                                                                setState(() {
                                                                  selectedPlayground =
                                                                      newValue;
                                                                  timeWidgets = fetchTime(selectedPlayground.id, date, isHalf);
                                                                });
                                                              },
                                                              items: snapshot
                                                                  .data
                                                                  .playgrounds
                                                                  .map<DropdownMenuItem<Playground>>(
                                                                      (Playground
                                                                          valuer) {
                                                                return DropdownMenuItem<
                                                                    Playground>(
                                                                  value: valuer,
                                                                  child: Text(valuer
                                                                      .sports[
                                                                          "name"]
                                                                      .toString()),
                                                                );
                                                              }).toList()),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 27, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text("Время",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat-Regular",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              130,
                                                              130,
                                                              130),
                                                          fontSize: 12,
                                                        )),
                                                    Text("Стоимость\nRUB",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat-Regular",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              130,
                                                              130,
                                                              130),
                                                          fontSize: 12,
                                                        )),
                                                    Text("Статус",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat-Regular",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              130,
                                                              130,
                                                              130),
                                                          fontSize: 12,
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ))),
                                ),
                                preferredSize: Size(double.infinity, 100),
                              )),
                        ),
                      ),
                    ];
                  },
                  body: FutureBuilder(
                    future: timeWidgets,
                    builder: (context, AsyncSnapshot snap) {
                     switch(snap.connectionState){
                       case ConnectionState.none:
                         return Container(child: Text("Нет соединения с интернетом"),);
                       case ConnectionState.waiting:
                         return Center(
                             child: CircularProgressIndicator()
                         );
                       default:
                      if (snap.hasData && snap.data.length >= 1) {
                        return (Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: snap.data
                                    .map<Widget>((time) => TimeWidget(time.id, time.from.toString().substring(0,5) + " - " + time.to.toString().substring(0,5),
                                        time.price.toString(), !time.isBooked))
                                    .toList(),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56,
                                child: FlatButton(
                                    child: new Text("Забронировать",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontFamily: "Montserrat-Bold")),
                                    onPressed: () async{
                                      if(ids.length >= 1){
                                        bool test = await Navigator.push(context,  MaterialPageRoute(builder: (context) => PayScreen(date: date)));
                                        setState(() {
                                          if(test) {
                                            timeWidgets = fetchTime(selectedPlayground.id, date, isHalf);
                                          }
                                        });
                                      }
                                    }),
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                    color: Color.fromARGB(255, 47, 128, 237)),
                                margin: EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 21.0),
                              )
                            ],
                          ),
                        ));
                      } else {
                        return Container(child: Text("На выбранную дату нет свободных мест", style: TextStyle(
                            color: Color.fromARGB(255, 130, 130, 130),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat-Regular")),
                        alignment: Alignment.topCenter, margin: EdgeInsets.only(top: 16),);
                      }
                     }
                    },
                  ));
            } else {
              return Center(
                  child: Container(
                child: SizedBox(
                    child: CircularProgressIndicator(), width: 30, height: 30),
              ));
            }
          },
        ));
  }
}

class TimeWidget extends StatefulWidget {
  int id;
  String time;
  String price;
  bool isActive;

  TimeWidget(this.id, this.time, this.price, this.isActive);

  @override
  _TimeWidgetState createState() => _TimeWidgetState(id, time, price, isActive);
}

class _TimeWidgetState extends State<TimeWidget> {
  int id;
  String time;
  String price;
  String status = "Занято";
  bool isActive;
  bool setTime = false;

  _TimeWidgetState(this.id,this.time, this.price, this.isActive);

  @override
  void initState() {
    if (isActive) {
      status = "Свободно";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: setTime ? Color.fromARGB(255, 47, 128, 237) : Colors.white,
        margin: EdgeInsets.only(left: 8, right: 8),
        padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                time,
                style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? (setTime
                          ? Colors.white
                          : Color.fromARGB(255, 47, 128, 237))
                      : Color.fromARGB(255, 130, 130, 130),
                  fontSize: 16,
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: Text(
                "\t\t" + price,
                style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? (setTime
                          ? Colors.white
                          : Color.fromARGB(255, 47, 128, 237))
                      : Color.fromARGB(255, 130, 130, 130),
                  fontSize: 16,
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? (setTime
                          ? Colors.white
                          : Color.fromARGB(255, 47, 128, 237))
                      : Color.fromARGB(255, 130, 130, 130),
                  fontSize: 16,
                ),
              ),
              flex: 3,
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          if (isActive) {
            if(!setTime) {
              ids.add(id.toString());
            } else {
              ids.remove(id.toString());
            }
              setTime = !setTime;
          }
        });
      },
    );
  }
}
