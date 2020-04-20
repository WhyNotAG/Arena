import 'dart:math';

import 'package:arena/Menu.dart';
import 'package:arena/Navigation/Places/Place/Booking.dart';
import 'package:arena/Navigation/Places/Place/Place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:arena/Authorization/Registration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';


class Data {
  var _myController = TextEditingController();
  var _passController = TextEditingController();
  bool isPhone = false;
  var code;
}

void main() async {
  Widget _defaultHome = ArenaApp();
  Intl.defaultLocale = "ru";
  WidgetsFlutterBinding.ensureInitialized();
  var token = await getStringValuesSF("accessToken");

  if(token != null) { _defaultHome = MenuScreen(); }
  
  runApp(new MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.transparent,
          primaryColor: Colors.white,
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          )),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/first': (context) => ArenaApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => MenuScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: _defaultHome));


}

String name;
String password;

addStringToSF(String name, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name, value);
}



class ArenaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "ru";
    Data data = Data();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BaseLayout(data)
    );
  }
}

class BaseLayout extends StatelessWidget {
  Data data;

  BaseLayout(this.data);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Stack(children: <Widget>[
          new Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login.jpeg"),
                    fit: BoxFit.cover)
            ),
          ),
          Container(child: new Info(data),)
        ],)

    );
  }
}


class Info extends StatelessWidget {
  Data data;
  Info(this.data);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( child: Container(
        padding: EdgeInsets.only(bottom: 0.0, top: 0.0),
        child: new Center(
            child: new Column(children: <Widget>[
              new Container(
                child: new Text("Новый пользователь?", style: new TextStyle(
                    color: Color.fromARGB(255, 130, 130, 130), fontSize: 12.0,
                    fontFamily: 'Montserrat-Bold')),
                margin: EdgeInsets.only(top: 76.0, bottom: 0.0),
              ),
              new Container(
                child: new RegButton(),
                margin: EdgeInsets.only(bottom: 50.0),
              ),
              new Container(
                  child: new Logo()
              ),
              new Container(
                child: new InfoFields(data),
              ),
              WithoutRegButton()
            ],)
        )
      )
    );
  }
}

class RegButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    }, child: new Text(
        "Зарегистрируйтесь",
        style: TextStyle(
            decoration: TextDecoration.underline, fontSize: 14.0,
            fontFamily: "Montserrat-Regular",
            fontWeight: FontWeight.bold)
    ),
      padding: EdgeInsets.all(0.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textColor: Color.fromARGB(255, 79, 79, 79),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 104.0, right: 104.0,),
      margin: EdgeInsets.only(bottom: 40.0),
      width: 167,
      height: 154,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/LOGO.png"), fit: BoxFit.contain)
      ),
    );
  }
}

//
//
class InfoFields extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  Data data;

  InfoFields(this.data);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
            height: 56,
            margin: EdgeInsets.only(left:16.0, right: 16.0),
            child: Container(
                height: 56,
                child: Form(key: _formKey,
                  child: new TextFormField(
                    controller: data._myController,
                    focusNode: myFocusNode,
                    validator: (value){
                      if (value.isEmpty) return 'Пожалуйста введите свой Email';
                      String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                      RegExp regExp = new RegExp(p);

                      String p2 = "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}\$";
                      RegExp regExp2 = new RegExp(p2);
                      if (regExp.hasMatch(value)) return null;
                      if (regExp2.hasMatch(value)) { data.isPhone = true; return null;}
                      return 'Это не E-mail';
                    },

                  cursorColor: Colors.black38,
                  decoration: new InputDecoration(
                    hintText: "Email/Phone",
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.green : Colors.black,
                    ),

                    errorStyle: TextStyle(fontSize: 0.0, ),
                    errorBorder: (
                        OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red, width: 2.0),
                        )
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 2.0),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0,),
                    ),


                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 10.0, 10.0, 10.0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
              )
            )
          )
        ),
        Password(data:data),
        Container(child: LostPass(),alignment: Alignment.centerRight,),
        EnterButton(_formKey,_formKey2, data, data.isPhone)
      ],
    );
  }
}


//
//
//Password widget
class Password extends StatefulWidget {
  Data data;

  Password({Key key, @required this.data}) : super(key: key);


  @override
  _PasswordState createState() => _PasswordState(data);
}

class _PasswordState extends State<Password> {
  Data data;
  var _controller = TextEditingController();
  bool _obscureText = true;
  IconData _icon = Icons.visibility_off;


  _PasswordState(this.data);

  void setIcon(bool obscure) {
    setState(() {
      if(obscure){ _icon = Icons.visibility_off;}
      else { _icon =  Icons.visibility;}
    });
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    data._passController = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56,
        margin: EdgeInsets.only(left:16.0, right: 16.0),
        child: Container(
          child: Form(
            child: new TextFormField(
            obscureText: _obscureText,
            controller: widget.data._passController,
            cursorColor: Colors.black,
            decoration: new InputDecoration(
              hintText: "Пароль",
              hintStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              errorStyle: TextStyle(fontSize: 0.0, ),
              focusedBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.red, width: 2.0),
              ) ,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.red, width: 2.0),
              ) ,
              contentPadding: new EdgeInsets.fromLTRB(
                  10.0, 10.0, 10.0, 10.0),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                    setIcon(_obscureText);
                  });
                },
                icon: Icon(_icon),
                color: Colors.black,
              ),
            ),
            )
        ),
        )
      );
  }
}

//
//Button lost password
class LostPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FlatButton(onPressed: null, child: new Text(
          "Забыли пароль?",
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline, fontSize: 12.0,
              fontFamily: "Montserrat-Regular",
              fontWeight: FontWeight.bold)
      ),

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

    );
  }
}


//Enter button
class EnterButton extends StatelessWidget {
  final _formKey;
  final _formKey2;
  Data data;
  bool isPhone;
  EnterButton(this._formKey, this._formKey2, this.data, this.isPhone);
  Future<int> httpGet(String password, String enter) async {
   var email;
   var phone;
    try {

      String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
      RegExp regExp = new RegExp(p);

      String p2 = "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}\$";
      RegExp regExp2 = new RegExp(p2);

      if (regExp.hasMatch(enter)) {
        email = enter;
        phone = null;
      }

      if(regExp2.hasMatch(enter)) {
        email = null;
        phone = enter;
      }

      Map jsonFile = {
          "email": email,
          "password": password,
          "number": phone,
        };

      print(jsonEncode(jsonFile));
      var response =
      await http.post("http://217.12.209.180:8080/api/v1/auth/sign-in",
          body:json.encode(jsonFile),
          headers: {"content-Type":"application/json"});
      print(response.statusCode);
      print(response.body);
      var decode = jsonDecode(response.body);
      addStringToSF("accessToken", decode["accessToken"]);
      addStringToSF("refreshToken", decode["refreshToken"]);
      addIntToSF("expiredIn", decode["expiredIn"]);
      addStringToSF("name", name);
      addIntToSF("enterCode", response.statusCode);
      addStringToSF("phone", null);
      addStringToSF("password", password);

      return response.statusCode;
    } catch(error) {print(error);}
  }

  test() async {
    print (await getStringValuesSF("password"));
  }

  Future<int> status() async {
    var a = await getIntValuesSF("enterCode");
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 56,
      child: FlatButton(child: new Text("Войти",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat-Bold")
      ),
        onPressed: () async{
          print(data._myController.text);
          print(data._passController.text);
          addStringToSF("password", data._passController.text);

          int a = 0;


          a = await httpGet(data._passController.text, data._myController.text);
          print(a);
          if(a == 200) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),);
          } else {Scaffold.of(context).showSnackBar(SnackBar(content:Text("Ошибка логин/пароль"), backgroundColor: Colors.red,));}
        },
      ),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(30.0),
          color: Color.fromARGB(255, 47, 128, 237)
      ),
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 21.0),
    );
  }



}

class WithoutRegButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 100.0, left: 59, right: 13.0),
        child: Row(
          children: <Widget>[
            new FlatButton(onPressed: (){Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen()),);},child: new Text(
                "Продолжить без регистрации",
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 14.0,
                    fontFamily: "Montserrat-Regular",
                    color: Colors.white)
            ),
                color: Colors.white.withAlpha(0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Colors.white),
            Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white,),
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),);}, color: Colors.white,)
            )
          ],)
    );
  }
}
