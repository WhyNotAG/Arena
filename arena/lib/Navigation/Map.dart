import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:ui' as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
import 'package:flutter/services.dart';

Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  // Read SVG file as String
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = 50 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 50 * devicePixelRatio; // same thing

  // Convert to ui.Picture
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}

class CustomMarker {
  var text;
  var info;
  var count;

  CustomMarker(this.text, this.info, this.count);
}

List<CustomMarker> parsePlace(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CustomMarker>((json) => Place.fromJson(json)).toList();
}

Future<Set<Marker>> fetchPlace(BuildContext context) async {
  List<Place> places = new List<Place>();
  Set<Marker> placeWidgets = new Set<Marker>();
  var response;

  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken("http://217.12.209.180:8080/api/v1/place/");
  } else {
    response = await http.get('http://217.12.209.180:8080/api/v1/place/',
        headers: {"Content-type": "application/json"});
  }

  List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    List list = json.decode(response.body) as List;
    int length = list.length;

    for (int i = 0; i < length; i++) {
      places.add(Place.fromJson(responseJson[i]));
      if (places[i].isFavourite == null) {
        places[i].isFavourite = false;
      }
      var count = places[i].countOfRate;
      if (count == null) {
        count = 0;
      }

//      for(int j = 0; j < places[i].playgrounds.length; j++)
//        {
//
//        }
      geo.Position position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      var img;

      if (places[i].playgrounds[0].sports["name"] == "Футбол") {
        img = "assets/images/Point_Soccer.svg";
      }
      if (places[i].playgrounds[0].sports["name"] == "Теннис") {
        img = "assets/images/Point_Tennis.svg";
      }
      if (places[i].playgrounds[0].sports["name"] == "Баскетбол") {
        img = "assets/images/Point_Basket.svg";
      }
      if (places[i].playgrounds[0].sports["name"] == "Волейбол") {
        img = "assets/images/Point_Volley.svg";
      }
      if (places[i].playgrounds.length > 1) {
        img = "assets/images/LOGO.svg";
      }

      double distanceInMeters = await geo.Geolocator().distanceBetween(position.latitude, position.longitude, places[i].latitude, places[i].longitude);
      placeWidgets.add(Marker(
          consumeTapEvents: true,
          markerId: MarkerId(places[i].id.toString()),
          infoWindow: InfoWindow(title: places[i].name),
          position: LatLng(places[i].latitude, places[i].longitude),
          icon: await _bitmapDescriptorFromSvgAsset(context, img),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                      child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  topRight: const Radius.circular(10.0))),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 39, left: 24),
                                    width: 250,
                                    child: Text(
                                      places[i].name,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "Montserrat-Bold",
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      height: 20,

                                      margin:
                                          EdgeInsets.only(top: 51, right: 32),
                                      child: Text(
                                        "${(distanceInMeters/1000).toStringAsFixed(1)} км",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Montserrat-Bold",
                                          fontSize: 14,
                                        ),
                                      ))
                                ],
                              ),
                              //${places[i].workDayStartAt.toString().replaceRange(5, 8, "-")+places[i].workDayEndAt.toString().replaceRange(5, 8, "")}
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 11, left: 24),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Время работы: ",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Montserrat-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        places[i].workDayStartAt.toString().replaceRange(5, 8, "-")+places[i].workDayEndAt.toString().replaceRange(5, 8, ""),
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "Montserrat-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 11, left: 24),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Адрес: ",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Montserrat-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        places[i].address,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "Montserrat-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          )),
                      height: 250,
                    ));
          }));
    }

    return placeWidgets;
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
  double latitude;
  double longitude;
  List<Playground> playgrounds;

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
      this.latitude,
      this.longitude,
      this.playgrounds});

  factory Place.fromJson(Map<String, dynamic> json) {
    var list = json['playgrounds'] as List;
    List<Playground> pl = list.map((i) => Playground.fromJson(i)).toList();
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
        latitude: json["latitude"] as double,
        longitude: json["longitude"] as double,
        playgrounds: pl);
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String search;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Set<Marker> _before_markers = {};
  bool onPressed = false;
  GoogleMapController _controller;
  LatLng pinPosition = LatLng(55.753878, 37.620851);
  LocationData currentLocation;
  var location = new Location();
  TextEditingController controller = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.753878, 37.620851),
    zoom: 14.4746,
  );

  void _getLocation() async {
    geo.Position position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.medium);
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 14.4746,target: LatLng(position.latitude, position.longitude,))));
  }
  @override
  void initState() {
    super.initState();
    fetchPlace(context).then((placesFromServer) {
      setState(() {
        _before_markers = placesFromServer;
        _before_markers.add(Marker(position:LatLng(55.753878, 37.620851), markerId: MarkerId("test")));
        _markers = _before_markers;
      });
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/Point_Basket.png');
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            GoogleMap(
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              markers: _markers,
              myLocationButtonEnabled: false,
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onCameraIdle: () {
                for(Marker marker in _markers){
                  _controller.hideMarkerInfoWindow(marker.markerId);
                }
              },
              onCameraMove: (CameraPosition position) {
                setState(() {
                  onPressed = false;
                });
              },
              onTap: (LatLng latLng) {
                setState(() {
                  onPressed = false;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: FloatingActionButton(
                          heroTag: "btn1",
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.white,
                          child: const Icon(CustomIcons.filter,
                              color: Color.fromARGB(255, 47, 128, 237),
                              size: 20.0),
                        ),
                        padding: EdgeInsets.only(left: 16.0),
                      ),
                      onPressed
                          ? Expanded(
                              child: Container(
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 47,
                              width: 268,
                              child: TextField(
                                controller: controller,
                                onChanged: (String value) {
                                  setState(() {
                                    search = value;
                                    controller.text = search;
                                    controller.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: controller.text.length));
                                    _markers = _before_markers
                                        .where((u) => (u.infoWindow.title
                                            .toLowerCase()
                                            .contains(value.toLowerCase())))
                                        .toSet();
                                  });
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: new EdgeInsets.fromLTRB(
                                        20.0, 10.0, 10.0, 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: new BorderSide(
                                        color:
                                            Color.fromARGB(255, 47, 128, 237),
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 47, 128, 237),
                                        width: 1.0,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        CustomIcons.search,
                                        color:
                                            Color.fromARGB(255, 47, 128, 237),
                                        size: 20,
                                      ),
                                      onPressed: () {},
                                    )),
                              ),
                            ))
                          : Container(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    onPressed = !onPressed;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                backgroundColor: Colors.white,
                                child: const Icon(CustomIcons.search,
                                    color: Color.fromARGB(255, 47, 128, 237),
                                    size: 20.0),
                              ),
                            )
                    ],
                  ),
                  Flexible(child: SizedBox(height: 408.0)),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 0.0),
                    child: FloatingActionButton(
                      heroTag: "plus",
                      onPressed: () {
                        _controller.animateCamera(CameraUpdate.zoomIn());
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.white,
                      child: const Icon(CustomIcons.plus,
                          color: Color.fromARGB(255, 47, 128, 237), size: 20.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 0.0),
                    child: FloatingActionButton(
                      heroTag: "minus",
                      onPressed: () {
                        _controller.animateCamera(CameraUpdate.zoomOut());
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.remove,
                        color: Color.fromARGB(255, 47, 128, 237),
                        size: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton(
                      heroTag: "findMe",
                      onPressed: (){
                        _getLocation();
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 47, 128, 237),
                        size: 25.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
