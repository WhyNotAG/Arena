import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  String result;
  var response;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 35, right: 16),
            child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text("Написать отзыв", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                        fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 79, 79, 79)),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 22),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                       style: TextStyle(fontFamily: "Montserrat-Regular",
                           fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                       minLines: 4,
                       decoration: InputDecoration(border: OutlineInputBorder(
                         borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 2.0),
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),),
                       hintText: "Расскажите о ваших впечатлениях",
                       hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                           fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                      onChanged: (value){
                        setState(() {
                          result = value;
                        });
                      },
                    ),
                  ),
                  Expanded(child:SizedBox(height: 400,)),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    height: 56,
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(border:
                    Border.all(color: Color.fromARGB(255, 47, 128, 237),width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(child: Text("Отправить отзыв",
                      style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                          color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),
                    onPressed: () async{
                      var token = await getStringValuesSF("accessToken");
                      if (token != null) {
                        response = await postWithToken("http://217.12.209.180:8080/api/v1/feedback/service", {"feedback" : result});
                      } else{
                        Navigator.pop(context);
                      }

                      if(response.statusCode == 200) {
                        Navigator.pop(context);
                      }
                    },),)
                ],
              ),
            ),
          ),
    );
  }
}

