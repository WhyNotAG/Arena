import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:arena/Filter.dart';

//public <Widget>[] httpGet(String email, String password) async {
//  try {
//
//    Map jsonFile = {
//      "email": email,
//      "password": password,
//      "number": null
//    };
//    print(jsonEncode(jsonFile));
//    var responce =
//    await http.post("http://217.12.209.180:8080/api/v1/auth/sign-in",
//        body:json.encode(jsonFile),
//        headers: {"content-Type":"application/json"});
//    print(responce.statusCode);
//    print(responce.body);
//    var decode = jsonDecode(responce.body);
//    addStringToSF("accessToken", decode["accessToken"]);
//    addStringToSF("name", name);
//    addStringToSF("phone", null);
//    addStringToSF("password", password);
//    addStringToSF("refreshToken", decode["refreshToken"]);
//  } catch(error) {print(error);}
//
//  return null;
//}

class Places extends StatefulWidget {
  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(168.0), child: TabBar(),),
        body: Container(
            color: Colors.white,
          child: SingleChildScrollView(child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PlaceWidget("Теннисный корт «Клуб тенниса»", 3.0, 52, "", "8:00-22:00",
                  "ул. Комсомольская, д. 2, корп. 1", "2 крытых корта премиум класса с профессиональным " +
                      "покрытием хард, комфортным освещением, оборудованные системой вентиляции и кондиционирования"),
              PlaceWidget("Теннисный корт «Клуб тенниса»", 3.0, 52, "", "8:00-22:00",
                  "ул. Комсомольская, д. 2, корп. 1", "2 крытых корта премиум класса с профессиональным " +
                      "покрытием хард, комфортным освещением, оборудованные системой вентиляции и кондиционирования")
            ],
          ),)
        )));
  }
}


class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      width: double.infinity,
      height: 168,
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
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TabBarButton(),
              TabBarField(),
            ],
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(left: 0, right: 0, top: 0),
            child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              TabBarFilter("Все виды"),
              TabBarFilter("Теннис"),
              TabBarFilter("Футбол"),
              TabBarFilter("Баскетбол"),
            ],
          ))
        ],),
    );
  }
}

class TabBarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),)
          ]
      ),
      child: IconButton(icon: Icon(CustomIcons.filter, color: Color.fromARGB(255, 47, 128, 237),), onPressed: (){Navigator.push(
      context, MaterialPageRoute(builder: (context) => Filter()),);}),
      margin: EdgeInsets.only(left: 17, top: 53),
    );
  }
}

class TabBarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),)
          ]
      ),
      margin: EdgeInsets.only(top:56, left: 23, right: 16),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: new EdgeInsets.fromLTRB(
                20.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 1.0,),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey.withAlpha(0),
              ),
            ),
            fillColor: Colors.white,
            suffixIcon: IconButton(icon: Icon(CustomIcons.search, color: Color.fromARGB(255, 47, 128, 237), size: 20,), onPressed: (){},)
        ),
      ),
      )
    );
  }
}


class TabBarFilter extends StatelessWidget {
  String text;

  TabBarFilter(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),)
          ]
      ),
      width: 120,
      height: 32,
      margin: EdgeInsets.only(left: 8, right: 8, top: 1, bottom: 1),
      child: FlatButton(child: Text(text, style: TextStyle(color: Colors.black54),), onPressed:(){}),
    );
  }
}


class PlaceWidget extends StatelessWidget {
  String name;
  double rating;
  int countOfRate;
  String photo;
  String timeOfWork;
  String address;
  String info;


  PlaceWidget(this.name, this.rating, this.countOfRate, this.photo,
      this.timeOfWork, this.address, this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Color.fromARGB(255, 47, 128, 237),
          width: 1.5
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 24),
        child: Column(
        children: <Widget>[
          new Container(
            child: Text(name,
              style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
            ),
            width: double.infinity,
            margin: EdgeInsets.only(left: 24.0, right: 16.0),
          ),
          Container(
              child: new Row(children: <Widget>[
                Flexible(child:InfoPlace(rating, countOfRate)),
                FavouritesButton(),
              ],
              ),),
          WorkTimeWidget("Время работы: ", timeOfWork),
          WorkTimeWidget("Адрес:", address),
          PlaceButtons(),
          Container(
            margin: EdgeInsets.only(left: 25, right: 24, top: 26),
            child: Text(info, style: TextStyle(fontSize: 14, fontFamily: "Montserrat-Regular"),),
          ),
          PhotoPage(),
          ],
        ),
        )
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
        Expanded(child:Container(
          margin: EdgeInsets.only(left: 22.0, top: 0),
            child: SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: rating,
                size: 14.0,
                filledIconData: CustomIcons.fill_star,
                defaultIconData: CustomIcons.star,
                //halfFilledIconData: CustomIcons.fill_star,
                color: Colors.orangeAccent,
                borderColor: Colors.orangeAccent,
                spacing:0.0
            ),
          ),),
          Container(
            child: Text(rating.toString(),
            style: TextStyle(fontFamily: "Montserrat-Bold",
            fontSize: 16,),
            textAlign: TextAlign.start,),
            margin: EdgeInsets.only(left: 12, top: 0),
            ),
          Container(
            child: Text("${countOfRate.toString()} оценки",
            style: TextStyle(fontFamily: "Montserrat-Regular",
            fontSize: 13,),
            textAlign: TextAlign.start,),
            margin: EdgeInsets.only(left: 13, top: 0),
            )
          ]
        )
      );
  }
}

class WorkTimeWidget extends StatelessWidget {
  String name;
  String param;


  WorkTimeWidget(this.name, this.param);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 24.0, bottom: 7.0 ),
        child: new Row(children: <Widget>[
          Text(name,
            style: TextStyle(fontFamily: "Montserrat-Regulad", color: Colors.black54, fontSize: 14),
          ),
          Expanded(child: Container(
          margin: EdgeInsets.only(left: 8.0),
          child: Text(param,
          style: TextStyle(fontFamily: "Montserrat-Bold", color: Colors.black54, fontSize: 14),
            ),))]
          ));
  }
}


class FavouritesButton extends StatefulWidget {
  @override
  _FavouritesButtonState createState() => _FavouritesButtonState();
}

class _FavouritesButtonState extends State<FavouritesButton> {
  bool _favourite = false;
  IconData _icon = CustomIcons.star;

  void setIcon(bool obscure) {
    setState(() {
      if(obscure){ _icon = CustomIcons.fill_star;}
      else { _icon =  CustomIcons.star;}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 80, bottom: 0.0, right: 24),
      child: IconButton(icon: Icon(_icon, color: Colors.orangeAccent, size: 30,),
        onPressed:  () {
          setState(() {
            _favourite = !_favourite;
            setIcon(_favourite);
          });
        },),
    );
  }
}

class PlaceButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 19, right:24),
      width: double.infinity,
      child: new Row(
        children: <Widget>[
          Flexible(child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color.fromARGB(255, 47, 128, 237))
            ),
            width: 129,
            height: 40,
            margin: EdgeInsets.only(left: 25,),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Text("На карте", style: TextStyle(color: Colors.black, fontSize: 14),textAlign: TextAlign.center,),
                  ),),
                  Icon(CustomIcons.map_arrow, color: Color.fromARGB(255, 47, 128, 237), size: 16,)
                ],
              ),
            ),
          ),),

          Container(
            margin: EdgeInsets.only(left: 9),
            child: Text("8.5км", style: TextStyle(color: Colors.black38, fontFamily: "Montserrat-Bold", fontSize: 14),),),
          PlaceDateButton(),
          PlacePhoneButton()
        ],
      ),
    );
  }
}

class PlaceDateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 128, 237),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),)
          ]
      ),
      child: IconButton(icon: Icon(CustomIcons.day, color: Colors.white, size: 16,), onPressed: (){},),
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
            BoxShadow(color: Colors.grey,
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),)
          ]
      ),
      child: IconButton(icon: Icon(CustomIcons.phone, color: Colors.white, size: 16,), onPressed: (){},),
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
      child: Image(image: AssetImage("assets/images/testPhoto.png"), fit: BoxFit.fitHeight,),
    );
  }
}

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  PageController controller;

  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = PageController();
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
      child:PageIndicatorContainer(
        key: key,
        child: PageView(
          children: <Widget>[
            Image(image: AssetImage("assets/images/testPhoto.png"), fit: BoxFit.fitHeight,),
            Image(image: AssetImage("assets/images/testPhoto.png"), fit: BoxFit.fitHeight,),
            Image(image: AssetImage("assets/images/testPhoto.png"), fit: BoxFit.fitHeight,),
            Image(image: AssetImage("assets/images/testPhoto.png"), fit: BoxFit.fitHeight,),
          ],
          controller: controller,
          reverse: false,
        ),
        align: IndicatorAlign.bottom,
        length: 4,
        shape: IndicatorShape.circle(size: 10),
        indicatorColor: Colors.grey.withAlpha(200),
        indicatorSelectorColor: Colors.white,
        indicatorSpace: 10.0,
      ),

    );
  }
}
