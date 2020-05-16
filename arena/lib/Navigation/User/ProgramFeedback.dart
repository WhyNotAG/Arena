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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      onHorizontalDragCancel: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title:Text("Написать отзыв", textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Montserrat-Bold",
              fontSize: 24, color: Color.fromARGB(
                  255, 47, 128, 237)),),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 130, 130, 130), //change your color here
          ),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
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
                        hintText: "Расскажите о Ваших впечатлениях",
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
                        response = await postWithToken("${server}feedback/service", {"feedback" : result});
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
      ),
    );
  }
}

