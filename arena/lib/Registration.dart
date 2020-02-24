import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: new AppBar(
            title: new Text('Регистрация', style:
              TextStyle(color: Colors.black87, fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Color.fromARGB(255 , 141, 141, 141),),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.black38),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: new Container(child: new Center(
        child: new Column(
        children: <Widget>[
          Photo(),
          NameField(),
          EmailField(_formKey),
          Container(child:
            Password(),
            margin: EdgeInsets.only(top: 8),
          ),
          Container(
            margin: EdgeInsets.only(top: 36),
            child: RegistrationButton(_formKey),
          ),
          Container(child: WithoutRegButton2(),)
        ],
      ),
    )
    )
    );
  }
}

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(sourcePath: image.path,
    maxHeight: 512, maxWidth: 512, cropStyle: CropStyle.circle);
    setState(() {
      _image = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      child: FlatButton(child:
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)),color: Colors.grey,),
          height: 167,
          width: 167,
          child: _image == null ? new Align(child: new Text("Добавить фото",style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: "Montserrat-Bold",
              fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
          ), alignment: Alignment.center,) :
          Container(
            child: Container(padding: EdgeInsets.all(7.0),decoration: BoxDecoration(color: Colors.grey.withAlpha(10),), child: Container(
              padding: EdgeInsets.only(left:15.0, right:15.0),
              decoration: BoxDecoration(color:Color.fromARGB(120 , 141, 141, 141),
                image: DecorationImage(image: FileImage(_image),
                  fit: BoxFit.contain),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(100.0),
                    topRight: const Radius.circular(100.0),
                    bottomLeft: const Radius.circular(100.0),
                    bottomRight:const Radius.circular(100.0)),),
            ),),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                    image: FileImage(_image),
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    fit: BoxFit.contain)
            ),
            //padding: const EdgeInsets.all(20.0),
            ),
        ),
        onPressed:  (){
            getImage();
          },
      ),
    );
  }

}

class InfoFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: new Column(
      children: <Widget>[

      ],)
    );
  }
}

class EmailField extends StatelessWidget {
  final _formKey;
  FocusNode myFocusNode = new FocusNode();


  EmailField(this._formKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Form(key: _formKey, child:new TextFormField(
        focusNode: myFocusNode,
        validator: (value){
          if (value.isEmpty) return 'Пожалуйста введите свой Email';
          String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
          RegExp regExp = new RegExp(p);
          if (regExp.hasMatch(value)) return null;
          return 'Это не E-mail';
        },

        cursorColor: Colors.black38,
        decoration: new InputDecoration(
          labelText: 'ЭЛ.ПОЧТА/МОБ.ТЕЛЕФОН',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat-Bold',
              fontSize: 12,
              color: myFocusNode.hasFocus ? Colors.blue : Colors.black38,
              background: null,
              backgroundColor: null,
              decorationColor: null
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
            borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
          ),

          contentPadding: new EdgeInsets.fromLTRB(
              10.0, 10.0, 10.0, 10.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      ),
    );
  }
}

class NameField extends StatelessWidget {
  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 57.0, left: 16.0, right: 16.0),
      child: new TextFormField(
        focusNode: myFocusNode,
        cursorColor: Colors.black38,
        decoration: new InputDecoration(
          labelText: 'ИМЯ',
          labelStyle: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat-Bold',
              color: myFocusNode.hasFocus ? Colors.blue :Colors.black38,
              background: null,
              backgroundColor: null,
              decorationColor: null
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
            borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
          ),

          contentPadding: new EdgeInsets.fromLTRB(
              10.0, 10.0, 10.0, 10.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

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
        child: Form(
            child: new TextFormField(
              obscureText: _obscureText,
              controller: _controller,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                labelText: "ПАРОЛЬ",
                labelStyle: TextStyle(color: Colors.black38, fontFamily: 'Montserrat-Bold', fontSize: 12,),
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
                  color: Colors.black38,
                ),
              ),
            )
        )
    );
  }
}

class RegistrationButton extends StatelessWidget {
  final _formKey;

  RegistrationButton(this._formKey);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 56,
      child: FlatButton(child: new Text("Зарегестрироваться",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat-Bold")
      ),
        onPressed: () {
          if(_formKey.currentState.validate()) Scaffold.of(context).showSnackBar(SnackBar(content: Text('Форма успешно заполнена'), backgroundColor: Colors.green,));
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

class WithoutRegButton2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 130.0, left: 59, right: 13.0),
        child: Row(
          children: <Widget>[
            new FlatButton(onPressed: null,child: new Text(
                "Продолжить без регистрации",
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 14.0,
                    fontFamily: "Montserrat-Regular",
                    color: Color.fromARGB(255 , 141, 141, 141))
            ),
                color: Color.fromARGB(255 , 141, 141, 141),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Color.fromARGB(255 , 141, 141, 141)),
            Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: IconButton(icon: Icon(Icons.arrow_forward, color: Color.fromARGB(255 , 141, 141, 141),), onPressed: null, color: Colors.white,)
            )
          ],)
    );
  }
}