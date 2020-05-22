import 'dart:async';
import 'dart:io';

import 'package:arena/Navigation/Favourite.dart';
import 'package:arena/Navigation/Places/Places.dart';
import 'package:arena/Navigation/User/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/Map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Other/CustomSharedPreferences.dart';
import 'Other/Request.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async{
  int hour =  await getIntValuesSF("time");
  if(message["hour"] == hour.toString()) {
    if (message.containsKey('text')) {
      // Handle data message
      final dynamic data = message['text'];
    }

    if (message.containsKey('title')) {
      // Handle notification message
      final dynamic notification = message['title'];
    }

  } else {return;}
  // Or do other work.
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _text;
  String get text => _text;
  set text(String value) {
    _text = value;
    _controller.add(this);
  }

  String _title;
  String get title => _title;
  set title(String value) {
    _title = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () => CupertinoPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}
class DetailPage extends StatefulWidget {
  DetailPage(this.title);
  final String title;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
  StreamSubscription<Item> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.title];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Match ID ${_item.title}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          Text('Today match:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                          Text( _item.title, style: Theme.of(context).textTheme.title)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          Text('Score:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                          Text( _item.text, style: Theme.of(context).textTheme.title)
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['notification'] ?? message;
  final String itemTitle = data['title'];
  final Item item = _items.putIfAbsent(itemTitle, () => Item(itemId: itemTitle))
    .._title = data['matchteam']
    .._text = data['body'];
  return item;
}
class MenuScreen extends StatefulWidget {
  int _currentIndex;
  LatLng pinPosition;
  MenuScreen([this._currentIndex, this.pinPosition]);

  @override
  _MenuScreenState createState() => _MenuScreenState(_currentIndex, pinPosition);
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  LatLng pinPosition;
  _MenuScreenState(this._currentIndex, [this.pinPosition]);

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("${item.title} with score: ${item.text}"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context,  CupertinoPageRoute(builder: (context) => MenuScreen(0)),);
    }
  }

  @override
  void initState() {
    super.initState();
    update(String fbToken) async {
      var fbToken = await getStringValuesSF("fbToken");
     if(fbToken == null) {
       fbToken = _fcm.getToken();
       print("Instance ID: " + fbToken);
       addStringToSF("fbToken", fbToken);
       var response = await postWithToken(
           "${server}account/device/token",
           {"token": fbToken});

     }
      var token = await getStringValuesSF("accessToken");
      if (token != null) {
        int expIn = await getIntValuesSF("expiredIn");
        if( DateTime.fromMillisecondsSinceEpoch(expIn.toInt() * 1000).isBefore(DateTime.now())) {
          token = await refresh();
        }
      }
      print("Instance ID: " + fbToken);
    }
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));

      _fcm.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          String test = message["text"];
          int hour = await getIntValuesSF("time");
          print(hour);
            if(message["hours"] == hour.toString()) {
              showDialog(context: context,
                  builder: (context) => AlertDialog(
                    content:   Text("${test}\nЧерез ${message["hours"]}"),
                    title: Text("${message["title"]}"),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Закрыть'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  ));
            } else {return;}
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          int hour = await getIntValuesSF("time");
          if(message["hours"] != hour.toString()) {
            return;
          }
          print("onResume: $message");
          _navigateToItemDetail(message);
        },
      );
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
    }
    _fcm.getToken().then((token) =>
    {
      update(token)
    });
  }

  List<Widget> _children() =>  [
    MapSample(pinPosition: pinPosition,),
    Places(),
    Favourites(),
    User(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children( );
    return Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 47, 128, 237),
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.map_1,),
              title: new Text("Карта",
                style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center,)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.field,),
              title: new Text(" Площадки",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.star,),
              title: new Text("Избранное",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          ),

          BottomNavigationBarItem(
              icon: new Icon(CustomIcons.person,),
              title: new Text("Профиль",
                  style: TextStyle(color: Colors.black54, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center)
          )
        ],
      ),
    );
  }
}
