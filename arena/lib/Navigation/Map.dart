
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Notification.dart';
import 'package:arena/Other/Request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:ui' as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
import 'package:flutter/services.dart';
import 'Places/Filter.dart';
import 'Places/Place/Place.dart';

geo.Position position;

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

Future<List<Place>> fetchPlace(BuildContext context) async {
  List<Place> places = new List<Place>();
  Set<Marker> placeWidgets = new Set<Marker>();
  var response;

  position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.medium);
  var token = await getStringValuesSF("accessToken");
  int expIn = await getIntValuesSF("expiredIn");


  if (token != null) {
    if( DateTime.fromMillisecondsSinceEpoch(expIn.toInt() * 1000).isBefore(DateTime.now()))  {
      token = await refresh();
    }
    response = await getWithToken("${server}place/");
  } else {
    response = await http.get('${server}place/',
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
    }

    return places;
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
        this.latitude,
        this.longitude,
        this.playgrounds,
        this.customImages});

  factory Place.fromJson(Map<String, dynamic> json) {
    var list = json['playgrounds'] as List;
    List<Playground> pl = list.map((i) => Playground.fromJson(i)).toList();
    var listImages = json['images'] as List;
    List<CustomImage> img = listImages.map((i) => CustomImage.fromJson(i)).toList();
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
        playgrounds: pl,
        customImages: img);
  }
}

class MapSample extends StatefulWidget {
  LatLng pinPosition;

  MapSample({this.pinPosition});

  @override
  State<MapSample> createState() => MapSampleState(pinPosition);
}

class MapSampleState extends State<MapSample> {


  FocusNode _focusScope;
  String search;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Set<Marker> _before_markers = {};
  List<Place> places = List();
  List<Place> beforePlaces = List();
  ClusterManager _manager;
  bool onPressed = false;
  Completer<GoogleMapController> _controller = Completer();
  LatLng pinPosition;
  LocationData currentLocation;
  var location = new Location();
  List<ClusterItem<Place>> items = List();
  TextEditingController textController = TextEditingController();

  CameraPosition _kGooglePlex;

  void _getLocation() async {
    geo.Position position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.medium);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 14.4746,target: LatLng(position.latitude, position.longitude,))));
  }


  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Color.fromARGB(255, 47, 128, 237);
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
          (cluster) async {
            geo.Position position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.medium);
            var img;
            if (cluster.items.first.playgrounds[0].sports["name"] == "Футбол") {
              img = "assets/images/Point_Soccer.svg";
            }
            if (cluster.items.first.playgrounds[0].sports["name"] == "Теннис") {
              img = "assets/images/Point_Tennis.svg";
            }
            if (cluster.items.first.playgrounds[0].sports["name"] == "Баскетбол") {
              img = "assets/images/Point_Basket.svg";
            }
            if (cluster.items.first.playgrounds[0].sports["name"] == "Волейбол") {
              img = "assets/images/Point_Volley.svg";
            }
            if (cluster.items.first.playgrounds.length > 1) {
              img = "assets/images/arena.svg";
            }

            return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: !cluster.isMultiple ? () async{
            double distanceInMeters = await geo.Geolocator().distanceBetween(position.latitude, position.longitude, cluster.items.first.latitude, cluster.items.first.longitude);
            showModalBottomSheet(
                context: context,
                builder: (context) => InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaceInfoWidget(cluster.items.first.id)),
                    );
                  },
                  child: Container(
                    child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0))),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              width: 50,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 39, left: 24),
                                  width: 250,
                                  child: Text(
                                    cluster.items.first.name,
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
                                      cluster.items.first.workDayStartAt.toString().replaceRange(5, 8, "-")+cluster.items.first.workDayEndAt.toString().replaceRange(5, 8, ""),
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
                                      cluster.items.first.address,
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
                  ),
                ));
          } : () {},
          icon: cluster.isMultiple ? await _getMarkerBitmap(125,text: cluster.count.toString()) : await _bitmapDescriptorFromSvgAsset(context, img),
        );
      };

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this._markers = markers;
    });
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder, initialZoom: _kGooglePlex.zoom);
  }

  @override
  void initState() {
    if(pinPosition != null) {
      _kGooglePlex =  CameraPosition(
        target: pinPosition,
        zoom: 16,
      );
    } else{
      _kGooglePlex = CameraPosition(
        target: LatLng(55.753878, 37.620851),
        zoom: 14.4746,
      );
    }
    _focusScope = FocusNode();
    fetchPlace(context).then((placesFromServer) {
      setState(() {
        beforePlaces = placesFromServer;
        places = beforePlaces;
        for(Place place in places) {
          items.add(ClusterItem(LatLng(place.latitude, place.longitude), item: place));
          _manager.updateClusters();
        }
      });
    });
    _manager = _initClusterManager();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusScope.dispose();

    super.dispose();
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    markers: _markers,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapType: MapType.terrain,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _manager.setMapController(controller);
                    },
                    onCameraIdle: () {
                      _manager.updateMap();
                    },
                    onCameraMove: (CameraPosition position) {
                      setState(() {
                        onPressed = false;
                      });
                      _manager.onCameraMove(position);
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
                                onPressed: () async {
                                 beforePlaces = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Filter()),
                                  );
                                    items = new List();
                                   places = beforePlaces;
                                   print(places.length);
                                 if(places.length != 0) {
                                   for(Place place in places) {
                                     items.add(ClusterItem(LatLng(place.latitude, place.longitude), item: place));
                                     _manager.setItems(items);
                                   }
                                 } else {
                                   _markers = null;
                                   _manager.setItems(null);
                                 }
                                },
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
                                    focusNode: _focusScope,
                                    controller: textController,
                                    onChanged: (String value) {
                                      setState(() {
                                        search = value;
                                        textController.text = search;
                                        textController.selection =
                                            TextSelection.fromPosition(TextPosition(
                                                offset: textController.text.length));
                                        items = new List();
                                        places = beforePlaces
                                            .where((u) => (u.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase())))
                                            .toList();
                                        _markers = _before_markers
                                            .where((u) => (u.infoWindow.title
                                            .toLowerCase()
                                            .contains(value.toLowerCase())))
                                            .toSet();
                                        for(Place place in places) {
                                          items.add(ClusterItem(LatLng(place.latitude, place.longitude), item: place));
                                          _manager.setItems(items);
                                        }
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
                                    if(onPressed == true) {
                                      _focusScope.requestFocus();
                                    }
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
                            onPressed: () async{
                              final GoogleMapController controller = await _controller.future;
                              controller.animateCamera(CameraUpdate.zoomIn());
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
                            onPressed: () async {
                              final GoogleMapController controller = await _controller.future;
                              controller.animateCamera(CameraUpdate.zoomOut());
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
              ),
            )));
  }

  MapSampleState([this.pinPosition]);
}