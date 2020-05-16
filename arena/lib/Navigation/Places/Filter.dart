import 'dart:convert';

import 'package:arena/Other/CircleThumbShape.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import '../Map.dart';
import 'Places.dart';




class Subway {
  int id;
  double longitude;
  double latitude;
  String name;

  Subway({this.id, this.longitude, this.latitude, this.name});

  factory Subway.fromJson(Map<String, dynamic> json) {
    return Subway(
      id: json["id"] as int,
      longitude: json["longitude"] as double,
      latitude: json["latitude"] as double,
      name: json["name"] as String,
    );
  }
}

Future<List<Place>> fetchPlace(Map map) async {
  List<Place> places = new List<Place>();
  var response;

  var token = await getStringValuesSF("accessToken");

  String res = "";

  map.forEach((k,v) {
    if(v != null){
     res+= k.toString() + "=" + v.toString() + "&";
    }
  });

  res = res.substring(0, res.length-2);
  print(res);

  if (token != null) {
    response = await getWithToken("${server}place/?${res}");
  } else{
    response = await http.get("${server}place/?${res}",
        headers: {"Content-type": "application/json"});
  }

  List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 200) {
    List list = json.decode(response.body) as List;
    int length = list.length;
    print(length);
    for (int i = 0; i < length; i++) {
      places.add(Place.fromJson(responseJson[i]));
    }
    return places;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Subway>> fetchSubway() async {
  List<Subway> subways = new List<Subway>();
  var response;

  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken("${server}subway/");
  } else{
    response = await http.get("${server}subway/",
        headers: {"Content-type": "application/json"});
  }

  List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 200) {
    List list = json.decode(response.body) as List;
    int length = list.length;
    for (int i = 0; i < length; i++) {
      subways.add(Subway.fromJson(responseJson[i]));
    }
    return subways;
  } else {
    throw Exception('Failed to load album');
  }
}

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Map req = {
    "sports":null,
    "hasBaths": null,
    "hasInventory": null,
    "hasLockers": null,
    "hasParking": null,
    "openField": null,
    "priceFrom": 0,
    "priceTo": 50000,
    "subways":null,
  };

  var sportValue = ["Футбол", "Теннис", "Баскетбол", "Волейбол"];
  String sport;

  Future<List<Subway>> subways;
  List<Place> resPlace;
  Future places;
  Subway input;
  int minValue = 0;
  int maxValue = 5000;
  RangeValues _values = new RangeValues(0, 12000.0);
  var firstController = TextEditingController();
  var secondController = TextEditingController();

  bool hasParking = false;
  bool hasBaths = false;
  bool hasInventory = false;
  bool hasLockers = false;
  bool openField = true;
  bool closedField = true;

  bool isScroll = false;

  @override
  void initState() {
    initializeDateFormatting("ru", null);
    subways = fetchSubway();
    places = fetchPlace(req);
  }

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
          backgroundColor: Colors.white,
          appBar: PreferredSize(preferredSize: Size.fromHeight(112.0), child: TabBar(),),
          body: FutureBuilder<List<Subway>>(
            future: subways,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Container(color: Colors.white,child: SingleChildScrollView(child:Column(children: <Widget>[
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Column(children: <Widget>[
                        Container(child: Text("Вид спорта", textAlign: TextAlign.left, style: TextStyle(color: Color.fromARGB(255, 47, 128, 237)),),
                          width: double.infinity, margin: EdgeInsets.only(bottom: 8.0),),
                        Container(
                          decoration: BoxDecoration(color:Colors.white, boxShadow: [
                            BoxShadow(color: Colors.grey,
                              blurRadius: 2.0, // has the effect of softening the shadow
                              spreadRadius: 1.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                0.0, // vertical, move down 10
                              ),)
                          ]),
                          width: double.infinity,

                          child: Stack(children: <Widget>[
                            Align(child: Container(child: IconButton(icon: Icon(Icons.arrow_drop_down),),margin: EdgeInsets.only(right: 8.0),),alignment: Alignment.centerRight,),
                            Container(width: double.infinity,
                                margin: EdgeInsets.only(left: 16, right: 20),
                                child: Theme(
                                  data: ThemeData(
                                      canvasColor:
                                      Colors.white),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text("Все Виды"),
                                        iconSize: 24,
                                        style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                                        //elevation: 22,
                                        icon: Icon(Icons.close, color: Colors.red.withAlpha(0),),
                                        value: sport,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            sport = newValue;
                                            req["sports"] = newValue;
                                            places = fetchPlace(req);
                                          });
                                        },
                                        items: sportValue.map<DropdownMenuItem<String>>((String valuer) {
                                          return DropdownMenuItem<String>(
                                            value: valuer,
                                            child: Text(valuer),
                                          );
                                        }).toList()),),)),
                          ],),
                        )
                      ],)
                  ),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Column(children: <Widget>[
                        Container(child: Text("Метро", textAlign: TextAlign.left, style: TextStyle(color: Color.fromARGB(255, 47, 128, 237)),),
                          width: double.infinity, margin: EdgeInsets.only(bottom: 8.0),),
                        Container(
                          decoration: BoxDecoration(color:Colors.white, boxShadow: [
                            BoxShadow(color: Colors.grey,
                              blurRadius: 2.0, // has the effect of softening the shadow
                              spreadRadius: 1.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                0.0, // vertical, move down 10
                              ),)
                          ]),
                          width: double.infinity,

                          child: Stack(children: <Widget>[
                            Align(child: Container(child: IconButton(icon: Icon(Icons.arrow_drop_down),),margin: EdgeInsets.only(right: 8.0),),alignment: Alignment.centerRight,),
                            Container(width: double.infinity,
                                margin: EdgeInsets.only(left: 16, right: 20),
                                child: Theme(
                                  data: ThemeData(
                                      canvasColor:
                                      Colors.white),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        hint: Text("Не выбрано"),
                                        iconSize: 24,
                                        style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                                        //elevation: 22,
                                        icon: Icon(Icons.close, color: Colors.red.withAlpha(0),),
                                        value: input,
                                        onChanged: (Subway newValue) {
                                          setState(() {
                                            input = newValue;
                                            req["subways"] = newValue.id;
                                            places = fetchPlace(req);
                                          });
                                        },
                                        items: snapshot.data.map<DropdownMenuItem<Subway>>((Subway valuer) {
                                          return DropdownMenuItem<Subway>(
                                            value: valuer,
                                            child: Text(valuer.name),
                                          );
                                        }).toList()),),)),
                          ],),
                        )
                      ],)
                  ),
                  Container(
                      width: double.infinity,
                      //height: 30,
                      margin: EdgeInsets.only(left: 16, right: 20, top: 28),
                      child:  new Column(children: <Widget>[
                        Container(
                          width: double.infinity,
                          child:new Text("Тип площадки", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)), textAlign: TextAlign.left,),),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(child: Text("Открытая", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
                              Container(child: CupertinoSwitch(value: openField,
                                onChanged: (value) {
                                  setState(() {
                                    openField = value;
                                    if(!openField){
                                      closedField = true;
                                    }
                                    if(openField && closedField) {
                                      req["openField"] = null;
                                    } else {req["openField"] = openField;}
                                    places = fetchPlace(req);
                                  });
                                },
                                activeColor: Color.fromARGB(255, 47, 128, 237),),)
                            ],
                          ),),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(child: Text("Крытая", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),),),
                            Container(child: CupertinoSwitch(value: closedField,
                              onChanged: (value) {
                                setState(() {
                                  closedField = value;
                                  if(!closedField){
                                    openField = true;
                                  }
                                  if(openField && closedField) {
                                    req["openField"] = null;
                                  } else {req["openField"] = openField;}
                                  places = fetchPlace(req);
                                });
                              },
                              activeColor: Color.fromARGB(255, 47, 128, 237),),)
                          ],
                        ),
                        Container(margin: EdgeInsets.only(top: 23, left: 8, right: 8), height: 1, color: Color.fromARGB(100, 47, 128, 237) )
                      ],)),
                  Container(
                    margin: EdgeInsets.only(top: 28, left: 16, right: 20),
                    child: Column(children: <Widget>[
                      Container(width: double.infinity, child: Text("Дополнительно",
                        style: TextStyle(
                            fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,
                            fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)
                        ),
                      ),
                      ),
                      Container(child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(child: Text("Парковка", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
                          Container(child: CupertinoSwitch(value: hasParking,
                            onChanged: (value) {
                              setState(() {
                                hasParking = value;
                                req["hasParking"] = hasParking;
                                places = fetchPlace(req);
                              });
                            },
                            activeColor: Color.fromARGB(255, 47, 128, 237),),)
                        ],
                      ),),
                      Container(child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(child: Text("Инвентарь", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
                          Container(child: CupertinoSwitch(value: hasInventory,
                            onChanged: (value) {
                              setState(() {
                                hasInventory = value;
                                req["hasInventory"] = hasInventory;
                                places = fetchPlace(req);
                              });
                            },
                            activeColor: Color.fromARGB(255, 47, 128, 237),),)
                        ],
                      ),),
                      Container(child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(child: Text("Раздевалки", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
                          Container(child: CupertinoSwitch(value: hasLockers,
                            onChanged: (value) {
                              setState(() {
                                hasLockers = value;
                                req["hasLockers"] = hasLockers;
                                places = fetchPlace(req);
                              });
                            },
                            activeColor: Color.fromARGB(255, 47, 128, 237),),)
                        ],
                      ),),
                      Container(child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(child: Text("Душевые", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
                          Container(child: CupertinoSwitch(value: hasBaths,
                            onChanged: (value) {
                              setState(() {
                                hasBaths = value;
                                req["hasBaths"] = hasBaths;
                                places = fetchPlace(req);
                              });
                            },
                            activeColor: Color.fromARGB(255, 47, 128, 237),),)
                        ],
                      ),),
                    ],),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 28),
                      child: Column(children: <Widget>[
                        Container(width: double.infinity, child: Text("Стоиомость, RUB",
                          style: TextStyle(
                              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,
                              fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)
                          ),
                        ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 17),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(child: new Column(children: <Widget>[
                                Container(child:new Text("От", style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 12, fontWeight: FontWeight.bold)), width: 96, alignment: Alignment.topLeft,),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.withAlpha(75), width: 2),),
                                    width: 96,
                                    height: 40,
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if(!hasFocus) {
                                          setState(() {
                                            if(!isScroll){
                                              if (int.parse(firstController.text) <= 5000) {minValue = int.parse(firstController.text); firstController.text = minValue.toString();}
                                              if (minValue >= maxValue) { maxValue = 5000;}
                                              if(firstController.text == 0.toString()) {minValue = 10;}
                                              firstController.text = minValue.toString();
                                              req["priceFrom"] = minValue;
                                              req["priceTo"] = maxValue*10;
                                              places = fetchPlace(req);
                                            }
                                          });
                                        }
                                      },
                                      child: new TextField(style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                                          decoration: InputDecoration(border: InputBorder.none, contentPadding: new EdgeInsets.fromLTRB(
                                              10.0, 0.0, 10.0, 10.0),),
                                          controller: firstController,
                                          keyboardType: TextInputType.number),
                                    ))
                              ],),),
                              new Container(child:  new Column(children: <Widget>[
                                Container(child: new Text("До",
                                  style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 12, fontWeight: FontWeight.bold), ), width: 96,),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.withAlpha(75), width: 2),),
                                    width: 96,
                                    height: 40,
                                    child: Focus(
                                      onFocusChange: (hasFocus){
                                        if(!hasFocus){
                                          setState(() {
                                            if(!isScroll){
                                              if(int.parse(secondController.text) <= 5000) {maxValue = int.parse(secondController.text); secondController.text = maxValue.toString();}
                                              if (minValue >= maxValue) { minValue = 0;}
                                              if(secondController.text == 0.toString()) {maxValue = 5000;}
                                              secondController.text = maxValue.toString();
                                              req["priceFrom"] = minValue;
                                              req["priceTo"] = maxValue*10;
                                              places = fetchPlace(req);
                                            }
                                          });
                                        }
                                      },
                                      child: TextField(style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)), decoration: InputDecoration(border: InputBorder.none, contentPadding: new EdgeInsets.fromLTRB(
                                          10.0, 0.0, 10.0, 10.0),), controller: secondController,
                                          keyboardType: TextInputType.number),
                                    ))
                              ],))
                            ],),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 31),
                          child:SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color.fromARGB(255, 47, 128, 237),
                              thumbColor: Colors.grey,
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
                              thumbShape: CircleThumbShape(thumbRadius: 15),
                            ),
                            child: frs.RangeSlider(
                              min: 0.0,
                              max: 5000.0,
                              lowerValue: minValue.toDouble(),
                              upperValue: maxValue.toDouble(),
                              showValueIndicator: true,
                              valueIndicatorMaxDecimals: 1,
                              divisions: 500,
                              onChanged: (double newLowerValue, double newUpperValue) {
                                setState(() {
                                  isScroll = true;
                                  minValue = newLowerValue.toInt();
                                  firstController.text = minValue.toString();
                                  maxValue = newUpperValue.toInt();
                                  secondController.text = maxValue.toString();
                                });
                              },
                              onChangeEnd: (double newLowerValue, double newUpperValue) {
                                isScroll = false;
                                setState(() {
                                  req["priceFrom"] = newLowerValue;
                                  req["priceTo"] = newUpperValue*10;
                                  places = fetchPlace(req);
                                });
                              },
                            ),
                          ),),


                      ])
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(color: Colors.white,boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(50),
                        blurRadius: 1.0, // has the effect of softening the shadow
                        spreadRadius: -1.5, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          -4, // vertical, move down 10
                        ),
                      )
                    ],),
                    child: Column(children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 32),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Найдено мест",
                                style: TextStyle(fontFamily: "Montserrat-Regular",
                                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),),
                              FutureBuilder<List<Place>>(
                                future: places,
                                builder: (context, snapshotPlace){
                                  if(snapshotPlace.hasData) {
                                    resPlace = snapshotPlace.data;
                                    return Text(snapshotPlace.data.length.toString(), style: TextStyle(fontFamily: "Montserrat-Regular",
                                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),);
                                  } else {
                                    return Container(
                                      child: SizedBox(
                                          child: CircularProgressIndicator(), width: 30, height: 30),
                                    );
                                  }
                                },
                              )
                            ],)),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 12),

                        decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
                          color: Color.fromARGB(255, 47, 128, 237),),

                        width: double.infinity, height: 56,

                        child: FlatButton(child: Text("ПОКАЗАТЬ",
                          style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                              color: Colors.white, fontWeight: FontWeight.bold),),
                          onPressed: (){
                            Navigator.pop(context, resPlace);
                          },),),

                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 35),
                        decoration: BoxDecoration(border:
                        Border.all(color: Color.fromARGB(255, 47, 128, 237),width: 2),
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(child: Text("СБРОСИТЬ",
                          style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                              color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),
                          onPressed: (){
                            setState(() {
                              sport = null;
                              input = null;
                              minValue = 0;
                              maxValue = 5000;
                              firstController.text = 0.toString();
                              secondController.text = 5000.toString();
                              req["sports"] = null;
                              subways = null;
                              hasParking = false;
                              hasBaths = false;
                              hasInventory = false;
                              hasLockers = false;
                              openField = true;
                              closedField = true;
                              req["hasBaths"] =  null;
                              req["hasInventory"] = null;
                              req["hasLockers"] =  null;
                              req["hasParking"] =  null;
                              req["openField"] = null;
                              req["priceFrom"] =  0;
                              req["priceTo"]= 50000;
                              req["subways"] = null;
                              places = fetchPlace(req);
                            });
                          },
                        ),
                      )
                    ],),)
                ],),
                )
                );
              }else {
                return Center(
                    child: Container(
                      child: SizedBox(
                          child: CircularProgressIndicator(), width: 30, height: 30),
                    ));
              }
            },
          )
      ),
    );
  }
}



class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 60),
        width: double.infinity,
        height: 112,
        decoration: BoxDecoration(

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
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text("Фильтр", style: TextStyle(fontSize: 28, fontFamily: "Montserrat-Bold", color: Color.fromARGB(255, 79, 79, 79)),textAlign: TextAlign.left,),
              margin: EdgeInsets.only(left: 20.0), width: 120,
                height: 32,),
            Container(child: IconButton(icon: Icon(Icons.close), iconSize: 25, color: Color.fromARGB(255, 47, 128, 237), onPressed: (){Navigator.pop(context);},),padding: EdgeInsets.only(right:16), )
            //Container(child: IconButton(icon: Icon(CustomIcons.exit),),)
          ],
        ));
  }
}





