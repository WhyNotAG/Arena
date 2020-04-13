import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Place.dart';
import 'dart:math' as math;


List<String> test = ["test", "test2"];
String str = "test";

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

  Future place;


  @override
  void initState() {
    date = DateTime.now();
    place = fetchPlace(id);
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
                          handle:
                          NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context),
                          child: SliverSafeArea(
                            top: false,
                            bottom: false,
                            sliver: SliverAppBar(
                                actions: <Widget>[
                                  IconButton(
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
                                expandedHeight: 270.0,
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
                                                  margin: EdgeInsets.only(
                                                      top: 110),
                                                  height: 100,
                                                  color: Colors.black.withAlpha(
                                                      50),
                                                  padding: EdgeInsets.only(
                                                      top: 15),
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
                                                margin: EdgeInsets.only(
                                                    top: 80),
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        setPlaceIcon(
                                                            snapshot.data)),
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                ),
                                bottom: PreferredSize(
                                  child: Container(
                                    height: 150,
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
                                      child:Container(
                                          margin: EdgeInsets.only(left: 16, right: 16),
                                          child: Column(children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(top: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(date.toString(), style: TextStyle(
                                                    fontFamily: "Montserrat-Bold",
                                                    color: Color.fromARGB(255, 79, 79, 79),
                                                    fontSize: 22,
                                                  ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("15 авг", style: TextStyle(
                                                        fontFamily: "Montserrat-Regular",
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(255, 47, 128, 237),
                                                        fontSize: 12,
                                                      )),
                                                      Container(
                                                        child: Transform(
                                                          alignment: Alignment.center,
                                                          child:IconButton(icon: Icon(CustomIcons.arrowBack, size: 11,color: Color.fromARGB(255, 47, 128, 237),),),
                                                        transform: Matrix4.rotationY(math.pi),),)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                Row(children: <Widget>[
                                                  Text("Половина\nплощадки", style: TextStyle(
                                                    fontFamily: "Montserrat-Regular",
                                                    color: Color.fromARGB(255, 79, 79, 79),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                                  Transform.scale(child: CupertinoSwitch(value: true, activeColor: Color.fromARGB(255, 47, 128, 237),),
                                                  scale: 0.7,),
                                                ],),
                                                  Container(
                                                    decoration:BoxDecoration(color: Colors.white),
                                                    child:Theme(
                                                      data: ThemeData(canvasColor: Colors.white),
                                                      child: DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        focusColor: Colors.white,
                                                          iconSize: 24,
                                                          style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                                                          //elevation: 22,
                                                          value: str,
                                                          onChanged: (String newValue) {
                                                            setState(() {
                                                              str = newValue;
                                                            });
                                                          },
                                                          items: test.map<DropdownMenuItem<String>>((String valuer) {
                                                            return DropdownMenuItem<String>(
                                                              value: valuer,
                                                              child: Text(valuer),
                                                            );
                                                          }).toList()),),),)
                                              ],),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(right: 27, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Время", style: TextStyle(
                                                    fontFamily: "Montserrat-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 130, 130, 130),
                                                    fontSize: 12,
                                                  )),
                                                  Text("Стоимость\nRUB", style: TextStyle(
                                                    fontFamily: "Montserrat-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 130, 130, 130),
                                                    fontSize: 12,
                                                  )),
                                                  Text("Статус", style: TextStyle(
                                                    fontFamily: "Montserrat-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 130, 130, 130),
                                                    fontSize: 12,
                                                  )),
                                                ],),
                                            )
                                          ],))
                                    ),
                                  ), preferredSize: Size(double.infinity, 80),
                                )),
                          ),
                        ),
                      ];
                    },
                    body: Container(child: Text("Simple text"))
              );
            } else {
              return Center(
                  child: Container(
                    child: SizedBox(
                        child: CircularProgressIndicator(),
                        width: 30,
                        height: 30),
                  ));
            }
          },
        ));
  }
}
