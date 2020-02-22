import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:arena/Registration.dart';
void main() => runApp(ArenaApp());


class ArenaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BaseLayout()
    );
  }
}

class BaseLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: new Stack(children: <Widget>[
          new Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login.jpeg"),
                    fit: BoxFit.cover)
            ),
          ),
          new Info()
        ],)

    );
  }
}


class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                margin: EdgeInsets.only(bottom: 64.0),
              ),
              new Container(
                  child: new Logo()
              ),
              new Container(
                child: new InfoFields(),
              ),
              WithoutRegButton()
            ],)
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
        "Зарегестрируйтесь",
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
      margin: EdgeInsets.only(bottom: 56.0),
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
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
            height: 56,
            margin: EdgeInsets.only(left:16.0, right: 16.0),
            child: new TextField(
              cursorColor: Colors.black38,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black38,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
                ),
                contentPadding: new EdgeInsets.fromLTRB(
                    10.0, 10.0, 10.0, 10.0),
                //fillColor: Colors.green
                filled: true,
                fillColor: Colors.white,
                hintText: "Эл.почта/Моб.Телефон",
              ),)
        ),
        Password(),
        Container(child: LostPass(), margin: EdgeInsets.only(right: 0.0),),
        EnterButton()
      ],
    );
  }
}


//
//
//Password widget
class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var _controller = TextEditingController();
  bool _obscureText = true;
  IconData _icon = Icons.visibility_off;

  void setIcon(bool obscure) {
    setState(() {
      if(obscure){ _icon = Icons.visibility_off;}
      else { _icon =  Icons.visibility;}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56,
        margin: EdgeInsets.only(left:16.0, right: 16.0),
        child: new TextField(
          obscureText: _obscureText,
          controller: _controller,
          cursorColor: Colors.black38,
          decoration: new InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ),

            ),
            focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.red, width: 2.0),
            ) ,
            contentPadding: new EdgeInsets.fromLTRB(
                10.0, 10.0, 10.0, 10.0),
            //fillColor: Colors.green
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
              color: Colors.grey,
            ),
            hintText: "Пароль",
          ),)

    );
  }
}

//
//Button lost password
class LostPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Align(
      child: FlatButton(onPressed: null, child: new Text(
          "забыли пароль?",
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline, fontSize: 14.0,
              fontFamily: "Montserrat-Regular",
              fontWeight: FontWeight.bold)
      ),
        padding: EdgeInsets.only(left: 256, right: 4.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

    );
  }
}


//Enter button
class EnterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 56,
      child: FlatButton(onPressed: null, child: new Text("Войти",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat-Bold")
      ),
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
        margin: EdgeInsets.only(top: 130.0, left: 59, right: 13.0),
        child: Row(
          children: <Widget>[
            new FlatButton(onPressed: null, child: new Text(
                "Продолжить без регистрации",
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 14.0,
                    fontFamily: "Montserrat-Regular",
                    color: Colors.white)
            ),
                color: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Colors.white),
            Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white,), onPressed: null, color: Colors.white,)
            )
          ],)
    );
  }
}



