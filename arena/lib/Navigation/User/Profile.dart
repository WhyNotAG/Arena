import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:arena/Navigation/User/User.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  File _image;
  String _name;
  bool _obscureText = true;
  bool _obscureText2 = true;
  IconData _icon = Icons.visibility_off;
  IconData _icon2 = Icons.visibility_off;
  final passController = TextEditingController();
  final passReqController = TextEditingController();

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

  void setIcon(bool obscure) {
    setState(() {
      if (obscure) {
        _icon = Icons.visibility_off;
      } else {
        _icon = Icons.visibility;
      }
    });
  }

  void setIcon2(bool obscure) {
    setState(() {
      if (obscure) {
        _icon2 = Icons.visibility_off;
      } else {
        _icon2 = Icons.visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text("Редактирование профиля", textAlign: TextAlign.center,  style: TextStyle(fontFamily: "Montserrat-Bold",
                          fontSize: 24, color: Color.fromARGB(255,47, 128, 237)),),),
                    Container(
                      margin: const EdgeInsets.only(top: 32),
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
                      margin: EdgeInsets.only(top: 24) ,
                      width: double.infinity,
                      child: Text("Изменить фотографию", textAlign: TextAlign.center,  style: TextStyle(fontFamily: "Montserrat-Bold",
                          fontSize: 16, color: Color.fromARGB(255,47, 128, 237)),),),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 30),
                      child: Text("Изменить имя", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                          fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255,47, 128, 237))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 56,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "Montserrat-Regular",
                            fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                        minLines: 1,
                        decoration: InputDecoration(border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 1.0),
                        ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 1.0),),
                            hintText: "Имя",
                            hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                                fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                        onChanged: (value){
                          setState(() async {
                            _name = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
                        color: Color.fromARGB(255, 47, 128, 237),),
                      width: double.infinity, height: 56,
                      child: FlatButton(child: Text("Сохранить изменения",
                        style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                            color: Colors.white, fontWeight: FontWeight.bold),),
                        onPressed: () async {
                          var token = await getStringValuesSF("accessToken");
                          var id = await getIntValuesSF("id");
                          var expIn = await getIntValuesSF("expiredIn");

                          if( DateTime.fromMillisecondsSinceEpoch(expIn * 1000).isBefore(DateTime.now()))  {
                            token = await refresh();
                          }

                          if(_name != null) {
                            var response = await postWithToken('${server}account/', {"id": id, "firstName": _name});
                            var decode = jsonDecode(response.body);
                            addStringToSF("name", decode["firstName"]);
                            addStringToSF("imageUrl", decode["imageUrl"]);
                          }
                          if(_image != null) {
                            var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
                            var length = await _image.length();
                            var uri = Uri.parse('${server}account/upload/avatar/');
                            var request = new http.MultipartRequest("POST", uri);
                            request.files.add(http.MultipartFile('file', stream, length, filename: basename(_image.path), contentType: new MediaType('image', 'jpg')));
                            request.headers["Authorization"] = "Bearer ${token}";
                            request.headers["Content-type"]= "application/json";
                            var response = await request.send();
                            var response2 = await getWithToken("${server}account/");
                            var decode = jsonDecode(response2.body);
                            addStringToSF("name", decode["firstName"]);
                            addStringToSF("imageUrl", decode["imageUrl"]);
                          }

                          Navigator.pushNamed(context, "/user");
                        },),),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 40),
                      child: Text("Изменить пароль", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                          fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255,47, 128, 237))),
                    ),

                    Container(
                      child: Container(
                          height: 56,
                          child: Form(
                              child: new TextFormField(
                                obscureText: _obscureText,
                                controller: passController,
                                cursorColor: Colors.black,
                                //autofocus: true,
                                decoration: new InputDecoration(
                                  hintText: "СТАРЫЙ ПАРОЛЬ",
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
                      margin: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      child: Container(
                          height: 56,
                          child: Form(
                              child: new TextFormField(
                                obscureText: _obscureText2,
                                controller: passReqController,
                                cursorColor: Colors.black,
                                //autofocus: true,
                                decoration: new InputDecoration(
                                  hintText: "НОВЫЙ ПАРОЛЬ",
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
                                        _obscureText2 = !_obscureText2;
                                        setIcon2(_obscureText2);
                                      });
                                    },
                                    icon: Icon(_icon2),
                                    color: Colors.black38,
                                  ),
                                ),
                              )
                          )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      height: 56,
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
                      decoration: BoxDecoration(border:
                      Border.all(color: Color.fromARGB(255, 47, 128, 237),width: 2),
                          borderRadius: BorderRadius.circular(30)),
                      child: FlatButton(child: Text("Изменить пароль",
                        style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                            color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),
                        onPressed: () async{
                          if(passController.text != passReqController.text && passReqController != null && passController != null) {
                            var response = await postWithToken("${server}account/change-password",{"currentPassword": passController.text,
                              "newPassword": passReqController.text});
                            print(response.statusCode);
                            print(response.body);
                          }
                        },),
                    ),
//                Container(child: FlatButton(
//                    onPressed: (){
//                      showDialog(context: context,
//                          builder: (context) => AlertDialog(
//                            content:   Text("Вы действительно хотите удалить аккаунт?"),
//                            actions: <Widget>[
//                              FlatButton(
//                                child: const Text('Нет'),
//                                onPressed: () {
//                                  Navigator.pop(context, false);
//                                },
//                              ),
//                              FlatButton(
//                                child: const Text("Да"),
//                                onPressed: () async{
//                                  var token = await getStringValuesSF("accessToken");
//                                  var res = await http.delete("${server}account",headers: {"Content-type": "application/json", "Authorization": "Bearer ${token}"});
//                                  Navigator.pop(context, false);
//                                },
//                              ),
//                            ],
//                          ));
//                    },
//                    child: new Text(
//                    "Удалить аккаунт",
//                    style: TextStyle(
//                        decoration: TextDecoration.underline, fontSize: 14.0,
//                        fontFamily: "Montserrat-Regular",
//                        color:Color.fromARGB(255, 130, 130, 130))
//                ),
//                    color: Colors.white,
//                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                    textColor: Color.fromARGB(255, 130, 130, 130)),)
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
