import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:arena/Menu.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final enterController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxHeight: 512,
        maxWidth: 512,
        cropStyle: CropStyle.circle);
    setState(() {
      _image = croppedFile;
    });
  }

  bool _obscureText = true;
  IconData _icon = Icons.visibility_off;

  void setIcon(bool obscure) {
    setState(() {
      if (obscure) {
        _icon = Icons.visibility_off;
      } else {
        _icon = Icons.visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            brightness: Brightness.light,
            title: new Text(
              'Регистрация',
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 141, 141, 141),
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.black38),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
              child: new Container(
                  child: new Center(
            child: new Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 48),
                  child: FlatButton(
                    child: Container(
                      height: 167,
                      width: 167,
                      child: _image == null
                          ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100.0)),
                            color: Colors.grey,
                          ),
                          child: new Align(
                            child: new Text(
                              "Добавить фото",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: "Montserrat-Bold",
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            alignment: Alignment.center,
                          ))
                          : Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(120, 141, 141, 141),
                          image: DecorationImage(
                              image: FileImage(_image), fit: BoxFit.contain),
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(100.0),
                              topRight: const Radius.circular(100.0),
                              bottomLeft: const Radius.circular(100.0),
                              bottomRight: const Radius.circular(100.0)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 57.0, left: 16.0, right: 16.0),
                  child: new TextFormField(
                    controller: nameController,
                    //focusNode: myFocusNode,
                    //autofocus: true,
                    cursorColor: Colors.black38,
                    decoration: new InputDecoration(
                      hintText: 'ИМЯ',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat-Bold',
                          color: Colors.black38,
                          background: null,
                          backgroundColor: null,
                          decorationColor: null),
                      errorStyle: TextStyle(
                        fontSize: 0.0,
                      ),
                      errorBorder: (OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.red, width: 2.0),
                      )),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.red, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black38,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
                      ),
                      contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Form(
                    key: _formKey,
                    child: new TextFormField(
                      controller: enterController,
                      validator: (value) {
                        if (value.isEmpty) return 'Пожалуйста введите свой Email';
                        String p =
                            "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                        RegExp regExp = new RegExp(p);

                        String p2 =
                            "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}\$";
                        RegExp regExp2 = new RegExp(p2);
                        if (regExp2.hasMatch(value)) return null;

                        if (regExp.hasMatch(value)) return null;
                        return 'Это не E-mail';
                      },
                      //autofocus: true,
                      cursorColor: Colors.black38,
                      decoration: new InputDecoration(
                        hintText: 'ЭЛ.ПОЧТА/МОБ.ТЕЛЕФОН',
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 12,
                            color: Colors.black38,
                            background: null,
                            backgroundColor: null,
                            decorationColor: null),
                        errorStyle: TextStyle(
                          fontSize: 0.0,
                        ),
                        errorBorder: (OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red, width: 2.0),
                        )),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
                        ),
                        contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Container(
                      height: 56,
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Form(
                          child: new TextFormField(
                            obscureText: _obscureText,
                            controller: passController,
                            cursorColor: Colors.black,
                            //autofocus: true,
                            decoration: new InputDecoration(
                              hintText: "ПАРОЛЬ",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'Montserrat-Bold',
                                fontSize: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontSize: 0.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromARGB(255, 47, 128, 237), width: 2.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red, width: 2.0),
                              ),
                              contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                          ))),
                  margin: EdgeInsets.only(top: 8),
                ),
                Container(
                  margin: EdgeInsets.only(top: 36),
                  child: RegistrationButton(enterController.text, passController.text, nameController.text, _image),
                ),
              ],
            ),
          )))),
    );
  }
}

class RegistrationButton extends StatelessWidget {
  String enter;
  String password;
  String email;
  String name;
  String phone;
  File img;


  RegistrationButton(this.enter, this.password, this.name, this.img);

  @override
  Widget build(BuildContext context) {
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
      "number": phone,
      "email": email,
      "password": password
    };

    Map image = {
      "imageUrl": img.toString()
    };

    print(jsonFile);
    print(img.toString());

    return new Container(
      width: double.infinity,
      height: 56,
      child: FlatButton(
        child: new Text("Зарегистрироваться",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontFamily: "Montserrat-Bold")),
        onPressed: () async {
          var response =
          await http.post("http://217.12.209.180:8080/api/v1/auth/sign-up",
              body:json.encode(jsonFile),
              headers: {"content-Type":"application/json"});
          if(response.statusCode == 200) {
            response = await http.post("http://217.12.209.180:8080/api/v1/auth/sign-in",
                body:json.encode(jsonFile),
                headers: {"content-Type":"application/json"});
            if(response.statusCode == 200) {
              var decode = jsonDecode(response.body);
              addStringToSF("accessToken", decode["accessToken"]);
              addStringToSF("refreshToken", decode["refreshToken"]);
              addIntToSF("expiredIn", decode["expiredIn"]);

              if(response.statusCode == 200) {
                var token = await getStringValuesSF("accessToken");
                var stream = new http.ByteStream(DelegatingStream.typed(img.openRead()));
                var length = await img.length();
                var uri = Uri.parse('http://217.12.209.180:8080/api/v1/account/upload/avatar');
                var request = new http.MultipartRequest("POST", uri)
                ..files.add(await http.MultipartFile('imageUrl',stream, length, filename: basename(img.path)))
                ..headers["Authorization"] = "Bearer ${token}";
                var response2 = await request.send();
                if(response2.statusCode == 200) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                }
              }
            }
          }
        },
      ),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(30.0),
          color: Color.fromARGB(255, 47, 128, 237)),
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 21.0),
    );
  }
}
