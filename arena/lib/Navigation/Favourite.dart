import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Menu.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:page_indicator/page_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:arena/Other/Request.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'Map.dart';
import 'Places/Place/Booking.dart';
import 'Places/Place/Place.dart' as Pl;


Future<List<PlaceWidget>> placeWidgetFuture;
List<PlaceWidget> placeWidgets = List();
List<PlaceWidget> filteredList = List();

List<PlaceWidget> parsePlace(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<PlaceWidget>((json) => Place.fromJson(json)).toList();
}

Future<List<PlaceWidget>> fetchPlace() async {
  List<Place> places = new List<Place>();
  List<PlaceWidget> placeWidgets = new List<PlaceWidget>();

  geo.Position position = null;
  geo.GeolocationStatus geolocationStatus = await geo.Geolocator().checkGeolocationPermissionStatus();
  if(geolocationStatus != geo.GeolocationStatus.denied && geolocationStatus != geo.GeolocationStatus.disabled){
    position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.medium);
  }

  var response;
  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken("http://217.12.209.180:8080/api/v1/place/favorite/");
  } else{
    response = await http.get('http://217.12.209.180:8080/api/v1/place/favorite/',
        headers: {"Content-type": "application/json"});
  }



  List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    List list = json.decode(response.body) as List;
    int length = list.length;

    for (int i = 0; i < length; i++) {
      places.add(Place.fromJson(responseJson[i]));
      if (places[i].isFavourite == null) { places[i].isFavourite = false;}
      var count = places[i].countOfRate;
      if(count == null) {
        count = 0;
      }
      double distanceInMeters = position == null ? 0.0 : await geo.Geolocator().distanceBetween(position.latitude, position.longitude, places[i].latitude, places[i].longitude);
      placeWidgets.add(PlaceWidget(
          places[i].id,
          places[i].isFavourite,
          places[i].name,
          places[i].rating,
          distanceInMeters / 1000,
          count,
          "places[i].photo",
          (places[i].workDayStartAt.toString().replaceRange(5, 8, "-")+places[i].workDayEndAt.toString().replaceRange(5, 8, "")),
          places[i].address,
          places[i].info,
          places[i].customImages,
          places[i].latitude,
          places[i].longitude));
    }

    return placeWidgets;
  } else {
    throw Exception('Failed to load album');
  }
}

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}



class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onHorizontalDragCancel: (){
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(

                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(168.0),
                  child: Container(
                      padding: EdgeInsets.only(),
                      width: double.infinity,
                      height: 168,
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                          // has the effect of softening the shadow
                          spreadRadius: 0.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            10.0, // horizontal, move right 10
                            0.0, // vertical, move down 10
                          ),
                        )
                      ]),
                      child: Column(
                        children: <Widget>[
                          Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2.0,
                                        // has the effect of softening the shadow
                                        spreadRadius: 0.0,
                                        // has the effect of extending the shadow
                                        offset: Offset(
                                          0.0, // horizontal, move right 10
                                          0.0, // vertical, move down 10
                                        ),
                                      )
                                    ]),
                                margin: EdgeInsets.only(top: 56, left: 23, right: 16),
                                child: TextField(
                                  onChanged: (String value) {
                                    setState(() {
                                      placeWidgetFuture = fetchPlace();
                                      filteredList = placeWidgets
                                          .where((u) => (u.name
                                          .toLowerCase()
                                          .contains(value.toLowerCase())))
                                          .toList();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: new EdgeInsets.fromLTRB(
                                          20.0, 10.0, 10.0, 10.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: new BorderSide(
                                          color: Color.fromARGB(255, 47, 128, 237),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.grey.withAlpha(0),
                                        ),
                                      ),
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          CustomIcons.search,
                                          color: Color.fromARGB(255, 47, 128, 237),
                                          size: 20,
                                        ),
                                      )),
                                ),
                              )),
                          Container(
                            child: Text(
                              "Избранное",
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "Montserrat-Bold",
                              ),
                              textAlign: TextAlign.left,
                            ),
                            margin: EdgeInsets.only(top: 13.0, left: 20.0),
                            width: double.infinity,
                          )
                        ],
                      )),
                ),
                body: FutureBuilder<List<PlaceWidget>>(
                  future: placeWidgetFuture,
                  builder: (context, snapshot){
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
                        return Container(
                            margin: EdgeInsets.only(bottom: 0.0),
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: filteredList),
                            ));
                    }
                  },
                ))
        ));
  }

  @override
  void initState() {
    placeWidgetFuture = fetchPlace().then((placesFromServer) {
      setState(() {
        placeWidgets = placesFromServer;
        filteredList = placesFromServer;
      });
      return placesFromServer;
    });
  }
}


class PlaceWidget extends StatelessWidget {
  int id;
  bool isFavourite;
  String name;
  double rating;
  int countOfRate;
  String photo;
  String timeOfWork;
  double distance;
  String address;
  String info;
  double latitude;
  double longitude;
  List<CustomImage> customImages;

  PlaceWidget(this.id, this.isFavourite, this.name, this.rating, this.distance,
      this.countOfRate, this.photo, this.timeOfWork, this.address, this.info, this.customImages, this.latitude, this.longitude);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
          borderRadius: BorderRadius.circular(3),
          border:
          Border.all(color: Color.fromARGB(255, 47, 128, 237), width: 1.5),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 24),
          child: Column(
            children: <Widget>[
              new Container(
                child: Text(
                  name,
                  style: TextStyle(
                      fontFamily: "Montserrat-Regular",
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                width: double.infinity,
                margin: EdgeInsets.only(left: 24.0, right: 16.0),
              ),
              Container(
                child: new Row(
                  children: <Widget>[
                    Flexible(child: InfoPlace(rating, countOfRate)),
                    FavouritesButton(isFavourite: isFavourite, id: id,),
                  ],
                ),
              ),
              WorkTimeWidget("Время работы: ", timeOfWork),
              WorkTimeWidget("Адрес:", address),
              PlaceButtons(id, distance, latitude, longitude),
              Container(
                margin: EdgeInsets.only(left: 25, right: 24, top: 26),
                child: Text(
                  info,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style:
                  TextStyle(fontSize: 14, fontFamily: "Montserrat-Regular",),
                ),
              ),
              PhotoPage(customImages),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Pl.PlaceInfoWidget(id)),
        ).then((_) {
          placeWidgetFuture = fetchPlace();
          placeWidgetFuture.then((value) {
            placeWidgets = value;
            filteredList = value;
          });
        });
      },
    );
  }
}

class InfoPlace extends StatelessWidget {
  double rating;
  int countOfRate;

  InfoPlace(this.rating, this.countOfRate);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Row(children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 22.0, top: 0),
            child: SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: rating,
                size: 14.0,
                filledIconData: CustomIcons.fill_star,
                defaultIconData: CustomIcons.star,
                halfFilledIconData: CustomIcons.fill_star,
                color: Colors.orangeAccent,
                borderColor: Colors.orangeAccent,
                spacing: 0.0),
          ),
          Container(
            child: Text(
              rating.toString(),
              style: TextStyle(
                fontFamily: "Montserrat-Bold",
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            margin: EdgeInsets.only(left: 12, top: 0),
          ),
          Expanded(child:   Container(
            child: Text(
              "${countOfRate.toString()} оценки",
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontFamily: "Montserrat-Regular",
                fontSize: 13,
              ),
              textAlign: TextAlign.start,
            ),
            margin: EdgeInsets.only(left: 13, top: 0),
          ),)
        ]));
  }
}

class WorkTimeWidget extends StatelessWidget {
  String name;
  String param;

  WorkTimeWidget(this.name, this.param);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 24.0, bottom: 7.0),
        child: new Row(children: <Widget>[
          Text(
            name,
            style: TextStyle(
                fontFamily: "Montserrat-Regulad",
                color: Colors.black54,
                fontSize: 14),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8.0),
                child: Text(
                  param,
                  style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      color: Colors.black54,
                      fontSize: 14),
                ),
              ))
        ]));
  }
}


class FavouritesButton extends StatefulWidget {
  bool isFavourite;
  int id;
  FavouritesButton({Key key, @required this.isFavourite, Key key2, @required this.id}) : super(key: key);

  @override
  _FavouritesButtonState createState() => _FavouritesButtonState(isFavourite, id);
}

class _FavouritesButtonState extends State<FavouritesButton> {
  bool _favourite;
  int id;
  IconData _icon;


  _FavouritesButtonState(this._favourite, this.id);

  @override
  void initState() {
    _icon = _favourite ? CustomIcons.fill_star : CustomIcons.star;
    super.initState();
  }

  Future<int> setFavourite(bool obscure) async{
    if(obscure) {
      await postWithToken("${server}favorite/mark/${id}");
    } else {
      await postWithToken("${server}favorite/unmark/${id}");
    }
  }

  void setIcon(bool obscure) async{
    await setFavourite(obscure);

    setState(() {
      if (obscure) {
        _icon = CustomIcons.fill_star;
      } else {
        _icon = CustomIcons.star;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, bottom: 0.0, right: 24),
      child: IconButton(
        icon: Icon(
          _icon,
          color: Colors.orangeAccent,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _favourite = !_favourite;
            setIcon(_favourite);
          });
        },
      ),
    );
  }
}

class PlaceButtons extends StatelessWidget {
  int id;
  double distance;
  double latitude;
  double longitude;

  PlaceButtons(this.id, this.distance, this.latitude, this.longitude);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 19, right: 24),
      width: double.infinity,
      child: new Row(
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color.fromARGB(255, 47, 128, 237))),
              width: 129,
              height: 40,
              margin: EdgeInsets.only(
                left: 25,
              ),
              child: FlatButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen(0, LatLng(latitude, longitude))),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "На карте",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Icon(
                      CustomIcons.map_arrow,
                      color: Color.fromARGB(255, 47, 128, 237),
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 9),
            child: Text(
              distance.toStringAsFixed(2) + "км",
              style: TextStyle(
                  color: Colors.black38,
                  fontFamily: "Montserrat-Bold",
                  fontSize: 14),
            ),
          ),
          PlaceDateButton(id),
          //PlacePhoneButton()
        ],
      ),
    );
  }
}

class PlaceDateButton extends StatelessWidget {
  int id;

  PlaceDateButton(this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 128, 237),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ]),
      child: IconButton(
        icon: Icon(
          CustomIcons.day,
          color: Colors.white,
          size: 16,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Booking(id)),
          );
        },
      ),
      margin: EdgeInsets.only(left: 22),
    );
  }
}

class PlacePhoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 128, 237),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ]),
      child: IconButton(
        icon: Icon(
          CustomIcons.phone,
          color: Colors.white,
          size: 16,
        ),
        onPressed: () {},
      ),
      margin: EdgeInsets.only(left: 17),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 16, left: 9, right: 9),
      child: Image(
        image: AssetImage("assets/images/testPhoto.png"),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class PhotoPage extends StatefulWidget {
  List<CustomImage> customImages;

  PhotoPage(this.customImages);

  @override
  _PhotoPageState createState() => _PhotoPageState(customImages);
}

class _PhotoPageState extends State<PhotoPage> {
  PageController controller;
  List<CustomImage> customImages;
  List<Widget> result = List();

  _PhotoPageState(this.customImages);

  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = PageController();
    for(int i = 0; i < customImages.length; i++) {
      result.add(Container(child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: customImages[i].thumbImage, fit: BoxFit.fill,),));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: EdgeInsets.only(top: 10, bottom: 16, left: 9, right: 9),
      child: PageIndicatorContainer(
        key: key,
        child: PageView(
          children: result,
          controller: controller,
          reverse: false,
        ),
        align: IndicatorAlign.bottom,
        length: customImages.length,
        shape: IndicatorShape.circle(size: 10),
        indicatorColor: Colors.grey.withAlpha(200),
        indicatorSelectorColor: Colors.white,
        indicatorSpace: 10.0,
      ),
    );
  }
}
