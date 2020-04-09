import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

String setPlaceIcon(Place place){

  if (place.playgrounds.length > 1) {
    return "assets/images/LOGO.png";
  }
  if (place.playgrounds[0].sports["name"] == "Футбол") {
    return "assets/images/Point_Soccer.png";
  }
  if (place.playgrounds[0].sports["name"] == "Теннис") {
    return "assets/images/Point_Tennis.png";
  }
  if (place.playgrounds[0].sports["name"] == "Баскетбол") {
    return "assets/images/Point_Basket.png";
  }
  if (place.playgrounds[0].sports["name"] == "Волейбол") {
    return "assets/images/Point_Volley.png";
  }

}

Future<Place> fetchPlace(int id) async {
  Place place = new Place();
  var response;

  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken("http://217.12.209.180:8080/api/v1/place/full/info/${id}");
  } else {
    response = await http.get('http://217.12.209.180:8080/api/v1/place/full/info/${id}',
        headers: {"Content-type": "application/json"});
  }

  Map<String, dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    place = Place.fromJson(responseJson);
    print(place.name);
    return place;
  } else {
    throw Exception('Failed to load album');
  }
}

class Playground {
  int id;
  bool openField;
  Map sports;

  Playground({this.id, this.openField, this.sports});

  factory Playground.fromJson(Map<String, dynamic> json) {
    return Playground(
        id: json["id"] as int,
        openField: json["openField"] as bool,
        sports: json["sport"] as Map);
  }
}

class CustomImage {
  String fullImage;
  String thumbImage;
  int id;
  int uploadTimestamp;

  CustomImage({this.fullImage, this.thumbImage, this.id, this.uploadTimestamp});

  factory CustomImage.fromJson(Map<String, dynamic> json) {
    return CustomImage(
        id: json["id"] as int,
        fullImage: json["fullImage"] as String,
        thumbImage: json["thumbImage"] as String,
        uploadTimestamp: json["uploadTimestamp"] as int);
  }

}

class Place {
  int id; //
  String name; //
  double rating; //
  int countOfRate; //
  String photo;
  String timeOfWork;
  String address; //
  String info; //
  bool isFavourite;
  String workDayEndAt;
  String workDayStartAt;
  List<Playground> playgrounds;
  List<CustomImage> customImages;

  Place(
      {this.id,
      this.name,
      this.rating,
      this.countOfRate,
      this.timeOfWork,
      this.address,
      this.info,
      this.isFavourite,
      this.workDayEndAt,
      this.workDayStartAt,
      this.playgrounds,
      this.customImages});

  factory Place.fromJson(Map<String, dynamic> json) {
    var list = json['playgrounds'] as List;
    List<Playground> pl = list.map((i) => Playground.fromJson(i)).toList();

    var listPhoto = json['images'] as List;
    List<CustomImage> img  = listPhoto.map((i) => CustomImage.fromJson(i)).toList();

    return Place(
        id: json["id"] as int,
        name: json["name"] as String,
        rating: json["rating"] as double,
        countOfRate: json["reviewsCount"] as int,
        address: json["address"] as String,
        info: json["description"] as String,
        isFavourite: json["isFavorite"] as bool,
        workDayEndAt: json["workDayEndAt"] as String,
        workDayStartAt: json["workDayStartAt"] as String,
        playgrounds: pl,
        customImages: img);
  }
}

class PlaceInfoWidget extends StatefulWidget {
  int id;

  PlaceInfoWidget(this.id);

  @override
  _PlaceInfoWidgetState createState() => _PlaceInfoWidgetState(id);
}

class _PlaceInfoWidgetState extends State<PlaceInfoWidget> {
  Future place;
  int id;


  _PlaceInfoWidgetState(this.id);
  
  @override
  void initState() {
      place = fetchPlace(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Place>(
          future: place,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                          NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          child: SliverSafeArea(
                            top: false,
                            bottom: false,
                            sliver: SliverAppBar(
                                actions: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      CustomIcons.star,
                                      size: 28,
                                      color: Colors.amber,
                                    ),
                                    padding: EdgeInsets.only(right: 21.0),
                                  )
                                ],
                                leading: IconButton(
                                  icon: Icon(
                                    CustomIcons.arrowBack,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                expandedHeight: 264.0,
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
                                              Stack(children: <Widget>[
                                                Center(child: Container(child: SizedBox(
                                                    child: CircularProgressIndicator(), width: 30, height: 30),)),
                                                new Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: FadeInImage.memoryNetwork(placeholder:
                                                    kTransparentImage, image: snapshot.data.customImages[0].fullImage, fit: BoxFit.fill)
                                                ),

                                              ],),
                                              Container(
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(top: 160),
                                                  height: 100,
                                                  color: Colors.black.withAlpha(50),
                                                  padding: EdgeInsets.only(top: 15),
                                                  child: Text(
                                                    snapshot.data.name,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 16, color: Colors.white),
                                                  )),
                                              Container(
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(top: 130),
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
                                    height: 56,
                                    width: double.infinity,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(70, 130, 130, 130),
                                              blurRadius: 10.0,
                                              // has the effect of softening the shadow
                                              spreadRadius: 0.0,
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0.0, // horizontal, move right 10
                                                10.0, // vertical, move down 10
                                              ),
                                            )
                                          ]),
                                      child: TabBar(
                                        labelColor: Color.fromARGB(255, 47, 128, 237),
                                        isScrollable: false,
                                        indicatorPadding: EdgeInsets.only(bottom: 12),
                                        unselectedLabelColor:
                                        Color.fromARGB(255, 130, 130, 130),
                                        indicatorWeight: 1,
                                        labelStyle: TextStyle(
                                          fontFamily: "Montserrat-Regular",
                                          fontSize: 14,
                                        ),
                                        tabs: [
                                          Tab(
                                            text: "Информация",
                                          ),
                                          Tab(
                                            text: "Фотографии",
                                          ),
                                          Tab(
                                            text: "Отзывы",
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Center(
                            child: Text("Sample text"),
                          ),
                        ),
                        Center(
                          child: Text("Sample text"),
                        ),
                        Center(
                          child: Text("Sample text"),
                        ),
                      ],
                    )),
              );
            } else {return Center(child: Container(child: SizedBox(
                child: CircularProgressIndicator(), width: 30, height: 30),));}
          },
        )
    );
  }
}



class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
