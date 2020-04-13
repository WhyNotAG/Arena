import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/Places/Place/Comment.dart';
import 'package:arena/Navigation/Places/Place/PhotoGrid.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

String setPlaceIcon(Place place) {
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
    response = await getWithToken(
        "http://217.12.209.180:8080/api/v1/place/full/info/${id}");
  } else {
    response = await http.get(
        'http://217.12.209.180:8080/api/v1/place/full/info/${id}',
        headers: {"Content-type": "application/json"});
  }

  Map<String, dynamic> responseJson =
  json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    place = Place.fromJson(responseJson);
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

class PhoneNumber {
  String number;

  PhoneNumber({this.number});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      number: json["number"] as String);
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
  bool hasParking;
  bool hasBaths;
  bool hasInventory;
  bool hasLockers;
  int area;
  String workDayEndAt;
  String workDayStartAt;
  List<Playground> playgrounds;
  List<CustomImage> customImages;
  List<PhoneNumber> phoneNumbers;

  Place({this.id,
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
    this.customImages,
    this.area,
    this.hasLockers,
    this.hasBaths,
    this.hasInventory,
    this.hasParking,
    this.phoneNumbers});

  factory Place.fromJson(Map<String, dynamic> json) {
    var list = json['playgrounds'] as List;
    List<Playground> pl = list.map((i) => Playground.fromJson(i)).toList();

    var listPhoto = json['images'] as List;
    List<CustomImage> img = listPhoto.map((i) => CustomImage.fromJson(i)).toList();

    var phoneList =  json["phoneNumbers"] as List;
    List<PhoneNumber> numbers = phoneList.map((i) => PhoneNumber.fromJson(i)).toList();

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
        customImages: img,
        hasBaths: json["hasBaths"] as bool,
        hasInventory: json["hasInventory"] as bool,
        hasLockers: json["hasLockers"] as bool,
        hasParking: json["hasParking"] as bool,
        area: json["area"] as int,
        phoneNumbers: numbers);
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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
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
                                    color: Colors.white,
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
                                                      top: 160),
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
                                                    top: 130),
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
                                    height: 56,
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
                                      child: TabBar(
                                        labelColor:
                                        Color.fromARGB(255, 47, 128, 237),
                                        isScrollable: false,
                                        indicatorPadding:
                                        EdgeInsets.only(bottom: 12),
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
                          child: InfoWidget(snapshot.data),
                        ),
                        PhotoGrid(snapshot.data),
                        CommentList(snapshot.data.id)
                      ],
                    )),
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

class InfoWidget extends StatelessWidget {
  Place place;

  InfoWidget(this.place);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 13),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Color.fromARGB(255, 47, 128, 237),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8,),
                    child: Text(
                      place.workDayStartAt.toString().replaceRange(5, 8, "-") +
                          place.workDayEndAt.toString().replaceRange(5, 8, ""),
                      style: TextStyle(
                        fontFamily: "Montserrat-Regular",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(children: <Widget>[
              Container(child: Text( place.phoneNumbers.length >= 1 ? place.phoneNumbers[0].number : "", style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,),)),
              Container(child: Text( place.phoneNumbers.length > 1 ? place.phoneNumbers[1].number : "", style: TextStyle(
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold,
                fontSize: 14,),)),
            ],)
          ],),
          AdditInfo(
              place.area.toString() + " м2", "Общая площадь", CustomIcons.s_all,
              2),
          AdditInfo(place.playgrounds.length.toString(), "Количество площадок",
              CustomIcons.countOfFields, 0),

          Container(
            margin: EdgeInsets.only(left: 22, top: 45),
            child: Table(children: addStatus(place)),)
        ],
      ),
    );
  }
}

class AdditInfo extends StatelessWidget {
  String text;
  String name;
  IconData icon;
  double pad;


  AdditInfo(this.text, this.name, this.icon, this.pad);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4, top: 22),
      child: Row(
        children: <Widget>[
          Container(
            width: 26,
            height: 26,
            padding: EdgeInsets.only(bottom: pad),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 47, 128, 237),
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 13),
            child: Text(name, style: TextStyle(
              color: Color.fromARGB(255, 130, 130, 130),
              fontFamily: "Montserrat-Regular",
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),),),
          Expanded(child: SizedBox(width: 120,),),
          Container(
            margin: EdgeInsets.only(left: 13),
            child: Text(text, style: TextStyle(
              fontFamily: "Montserrat-Regular",
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),),),
        ],
      ),
    );
  }
}


List<TableRow> addStatus(Place place) {
  List<Widget> trueList = List();
  bool open = false;
  bool close = false;

  if(place.hasParking){
      trueList.add(Status("assets/images/status/Parking.png", "Парковка"));
  }

  if(place.hasInventory){
    trueList.add(Status("assets/images/status/Inventory.png", "Инвентарь"));
  }

  if(place.hasLockers){
    trueList.add(Status("assets/images/status/Lock.png", "Раздевалки"));
  }

  if(place.hasBaths){
    trueList.add(Status("assets/images/status/Bath.png", "Душ"));
  }

  for(Playground playground in place.playgrounds) {
    if (playground.openField && !open) {
      open = true;
      trueList.add(Status("assets/images/status/OpenField.png", "Открытое поле"));
    }
    else if (!playground.openField && !close) {
      close = true;
      trueList.add(Status("assets/images/status/ClosedField.png", "Крытое поле"));
    }
  }

  if(trueList.length % 2 != 0) {
    trueList.add(Container());
  }

  List<TableRow> rows = new List();
  TableRow row = new TableRow(children: List());

  for (Widget status in trueList) {
    row.children.add(status);
    if(row.children.length == 2) {
      rows.add(row);
      row = TableRow(children: List());
    }
  }
  return rows;
}


class Status extends StatelessWidget {
  String img;
  String text;

  Status(this.img, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(children: <Widget>[
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(image: DecorationImage(
              image: AssetImage(img), fit: BoxFit.fill)
          ),
        ),
        Flexible(child:Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(text,
            overflow: TextOverflow.clip,style: TextStyle(
              fontFamily: "Montserrat-Regular",
              fontSize: 14,),
        )))
      ],),
    );
  }
}
